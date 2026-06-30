/*
 * Copyright 2020-2025 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springframework.security.oauth2.server.authorization.util;

/**
 * Internal class used for serialization across Spring Authorization Server classes.
 *
 * @author Anoop Garlapati
 * @since 0.0.1
 */
public final class SpringAuthorizationServerVersion {

	private static final int MAJOR = 1;

	private static final int MINOR = 5;

	// 特别说明：此处 PATCH 保持为 0，以维持与官方 1.5.x 序列化特征一致。
	// Maven 坐标版本为 1.5.8-nes.patch.1-SNAPSHOT，但不宜同步修改此处，以免破坏运行时版本检查逻辑。
	private static final int PATCH = 0;

	/**
	 * Global Serialization value for Spring Authorization Server classes.
	 */
	public static final long SERIAL_VERSION_UID = getVersion().hashCode();

	public static String getVersion() {
		return MAJOR + "." + MINOR + "." + PATCH;
	}

}
