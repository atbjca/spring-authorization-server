/*
 * Copyright 2020-2023 the original author or authors.
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
 * Internal class used for serialization across Spring Authorization Server
 * classes.
 *
 * @author Anoop Garlapati
 * @since 0.0.1
 */
public final class SpringAuthorizationServerVersion {
	private static final int MAJOR = 0;
	private static final int MINOR = 4;
	// 特别说明：此处的 PATCH 位保持为 5 (即 0.4.5)，以维持与官方对应版本的运行时特征一致。
	// 虽然 Maven 坐标中的版本号已提升至 0.4.16-nes.patch.1，但此处不建议同步修改，以免破坏针对 0.4.5 版本的逻辑检查。
	private static final int PATCH = 5;

	/**
	 * Global Serialization value for Spring Authorization Server classes.
	 */
	public static final long SERIAL_VERSION_UID = getVersion().hashCode();

	public static String getVersion() {
		return MAJOR + "." + MINOR + "." + PATCH;
	}
}
