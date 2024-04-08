Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DEB5027B;
	Mon,  8 Apr 2024 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569229; cv=none; b=FqE/an16NqeYH8fItQKulxnc6xyWb1oU+pxW/cEz7LNaCvKKApyq6GXBSQODU3aYlPwryA6vLf5VErZSTqM3kmXDkykdXEvSWSyoWRRJnRZgLoCLn15RzTWbuj36dgFI8dPGxJWDAIlFqF6OYj5Cf0f+Q5NjF9q0Mdg1LsVsVpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569229; c=relaxed/simple;
	bh=NY+y50EeFT3zDJgNa//Ls2FXBG/qKme14tasGwEfcRo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dma+0R1IpX+yKawIoNgF0n8fNK3KMVuKwM2lPxzINcOMWe53PKGQ3r9ayI0A6RBsCCtEomyoZZcrAziDZtBDXV/rF8FJo9WP8lpSkdkxUjvVYz1Dk4ogDE1Lw++zDBfshT7nnUkYZLvXrSrM4CQrlH9NkJKw0UwLpSu6ekzusbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VCkXC4RNWzwRZc;
	Mon,  8 Apr 2024 17:37:31 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id DA2B818007D;
	Mon,  8 Apr 2024 17:40:24 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:22 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 10/10] samples/landlock: Support socket protocol restrictions
Date: Mon, 8 Apr 2024 17:39:27 +0800
Message-ID: <20240408093927.1759381-11-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Add socket protocol control support in sandboxer demo. It's possible
to allow a sandboxer to create sockets with specified family(domain)
and type values. This is controlled with the new LL_SOCKET_CREATE
environment variable. Single token in this variable looks like this:
'FAMILY.TYPE', where FAMILY corresponds to one of the possible socket
family name and TYPE to the possible socket type name (see socket(2)).
Add ENV_TOKEN_INTERNAL_DELIMITER.

Add get_socket_protocol() method to parse socket family and type strings
to the appropriate constants. Add CHECK_DOMAIN() and CHECK_TYPE()
macroses to prevent copypaste.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 samples/landlock/sandboxer.c | 149 ++++++++++++++++++++++++++++++++---
 1 file changed, 136 insertions(+), 13 deletions(-)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index 32e930c85..4642a7437 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -14,6 +14,7 @@
 #include <fcntl.h>
 #include <linux/landlock.h>
 #include <linux/prctl.h>
+#include <linux/socket.h>
 #include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -55,8 +56,11 @@ static inline int landlock_restrict_self(const int ruleset_fd,
 #define ENV_FS_RW_NAME "LL_FS_RW"
 #define ENV_TCP_BIND_NAME "LL_TCP_BIND"
 #define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
+#define ENV_SOCKET_CREATE_NAME "LL_SOCKET_CREATE"
 #define ENV_DELIMITER ":"
 
+#define ENV_TOKEN_INTERNAL_DELIMITER "."
+
 static int parse_path(char *env_path, const char ***const path_list)
 {
 	int i, num_paths = 0;
@@ -85,6 +89,49 @@ static int parse_path(char *env_path, const char ***const path_list)
 
 /* clang-format on */
 
+#define CHECK_DOMAIN(domain_variant) \
+	do { \
+		if (strcmp(strdomain, #domain_variant) == 0) { \
+			protocol->domain = domain_variant; \
+			domain_parsed = 1; \
+			goto domain_check; \
+		} \
+	} while (0)
+
+#define CHECK_TYPE(type_variant) \
+	do { \
+		if (strcmp(strtype, #type_variant) == 0) { \
+			protocol->type = type_variant; \
+			type_parsed = 1; \
+			goto type_check; \
+		} \
+	} while (0)
+
+static int get_socket_protocol(char *strdomain, char *strtype,
+				struct landlock_socket_attr *protocol)
+{
+	int domain_parsed = 0, type_parsed = 0;
+
+	CHECK_DOMAIN(AF_UNIX);
+	CHECK_DOMAIN(AF_INET);
+	CHECK_DOMAIN(AF_INET6);
+
+domain_check:
+	if (!domain_parsed)
+		return 1;
+
+	CHECK_TYPE(SOCK_STREAM);
+	CHECK_TYPE(SOCK_DGRAM);
+
+type_check:
+	if (!type_parsed)
+		return 1;
+	return 0;
+}
+
+#undef CHECK_DOMAIN
+#undef CHECK_TYPE
+
 static int populate_ruleset_fs(const char *const env_var, const int ruleset_fd,
 			       const __u64 allowed_access)
 {
@@ -182,6 +229,58 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 	return ret;
 }
 
+static int populate_ruleset_socket(const char *const env_var,
+				const int ruleset_fd, const __u64 allowed_access)
+{
+	int ret = 1;
+	char *env_protocol_name, *env_protocol_name_next;
+	char *strprotocol, *strdomain, *strtype;
+	struct landlock_socket_attr protocol = {
+		.allowed_access = allowed_access,
+		.domain = 0,
+		.type = 0,
+	};
+
+	env_protocol_name = getenv(env_var);
+	if (!env_protocol_name)
+		return 0;
+	env_protocol_name = strdup(env_protocol_name);
+	unsetenv(env_var);
+
+	env_protocol_name_next = env_protocol_name;
+	while ((strprotocol = strsep(&env_protocol_name_next, ENV_DELIMITER))) {
+		strdomain = strsep(&strprotocol, ENV_TOKEN_INTERNAL_DELIMITER);
+		strtype   = strsep(&strprotocol, ENV_TOKEN_INTERNAL_DELIMITER);
+
+		if (!strtype) {
+			fprintf(stderr, "Failed to extract socket protocol with "
+							"unspecified type value\n");
+			goto out_free_name;
+		}
+
+		if (get_socket_protocol(strdomain, strtype, &protocol)) {
+			fprintf(stderr, "Failed to extract socket protocol with "
+							"domain: \"%s\", type: \"%s\"\n",
+				strdomain, strtype);
+			goto out_free_name;
+		}
+
+		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				      &protocol, 0)) {
+			fprintf(stderr,
+				"Failed to update the ruleset with "
+				"domain \"%s\" and type \"%s\": %s\n",
+				strdomain, strtype, strerror(errno));
+			goto out_free_name;
+		}
+	}
+	ret = 0;
+
+out_free_name:
+	free(env_protocol_name);
+	return ret;
+}
+
 /* clang-format off */
 
 #define ACCESS_FS_ROUGHLY_READ ( \
@@ -205,14 +304,14 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 
 /* clang-format on */
 
-#define LANDLOCK_ABI_LAST 4
+#define LANDLOCK_ABI_LAST 5
 
 int main(const int argc, char *const argv[], char *const *const envp)
 {
 	const char *cmd_path;
 	char *const *cmd_argv;
 	int ruleset_fd, abi;
-	char *env_port_name;
+	char *env_optional_name;
 	__u64 access_fs_ro = ACCESS_FS_ROUGHLY_READ,
 	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE;
 
@@ -220,18 +319,19 @@ int main(const int argc, char *const argv[], char *const *const envp)
 		.handled_access_fs = access_fs_rw,
 		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
 				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
 	};
 
 	if (argc < 2) {
 		fprintf(stderr,
-			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
+			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
 			"<cmd> [args]...\n\n",
 			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
-			ENV_TCP_CONNECT_NAME, argv[0]);
+			ENV_TCP_CONNECT_NAME, ENV_SOCKET_CREATE_NAME, argv[0]);
 		fprintf(stderr,
 			"Execute a command in a restricted environment.\n\n");
 		fprintf(stderr,
-			"Environment variables containing paths and ports "
+			"Environment variables containing paths, ports and protocols "
 			"each separated by a colon:\n");
 		fprintf(stderr,
 			"* %s: list of paths allowed to be used in a read-only way.\n",
@@ -240,7 +340,7 @@ int main(const int argc, char *const argv[], char *const *const envp)
 			"* %s: list of paths allowed to be used in a read-write way.\n\n",
 			ENV_FS_RW_NAME);
 		fprintf(stderr,
-			"Environment variables containing ports are optional "
+			"Environment variables containing ports or protocols are optional "
 			"and could be skipped.\n");
 		fprintf(stderr,
 			"* %s: list of ports allowed to bind (server).\n",
@@ -248,22 +348,25 @@ int main(const int argc, char *const argv[], char *const *const envp)
 		fprintf(stderr,
 			"* %s: list of ports allowed to connect (client).\n",
 			ENV_TCP_CONNECT_NAME);
+		fprintf(stderr,
+			"* %s: list of socket protocols allowed to be created.\n",
+			ENV_SOCKET_CREATE_NAME);
 		fprintf(stderr,
 			"\nexample:\n"
 			"%s=\"${PATH}:/lib:/usr:/proc:/etc:/dev/urandom\" "
 			"%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
 			"%s=\"9418\" "
 			"%s=\"80:443\" "
+			"%s=\"AF_INET6.SOCK_STREAM:AF_UNIX.SOCK_STREAM\" "
 			"%s bash -i\n\n",
 			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
-			ENV_TCP_CONNECT_NAME, argv[0]);
+			ENV_TCP_CONNECT_NAME, ENV_SOCKET_CREATE_NAME, argv[0]);
 		fprintf(stderr,
 			"This sandboxer can use Landlock features "
 			"up to ABI version %d.\n",
 			LANDLOCK_ABI_LAST);
 		return 1;
 	}
-
 	abi = landlock_create_ruleset(NULL, 0, LANDLOCK_CREATE_RULESET_VERSION);
 	if (abi < 0) {
 		const int err = errno;
@@ -325,6 +428,16 @@ int main(const int argc, char *const argv[], char *const *const envp)
 			"provided by ABI version %d (instead of %d).\n",
 			LANDLOCK_ABI_LAST, abi);
 		__attribute__((fallthrough));
+	case 4:
+		/* Removes socket support for ABI < 5 */
+		ruleset_attr.handled_access_socket &=
+			~LANDLOCK_ACCESS_SOCKET_CREATE;
+		fprintf(stderr,
+			"Hint: You should update the running kernel "
+			"to leverage Landlock features "
+			"provided by ABI version %d (instead of %d).\n",
+			LANDLOCK_ABI_LAST, abi);
+		__attribute__((fallthrough));
 	case LANDLOCK_ABI_LAST:
 		break;
 	default:
@@ -338,18 +451,23 @@ int main(const int argc, char *const argv[], char *const *const envp)
 	access_fs_rw &= ruleset_attr.handled_access_fs;
 
 	/* Removes bind access attribute if not supported by a user. */
-	env_port_name = getenv(ENV_TCP_BIND_NAME);
-	if (!env_port_name) {
+	env_optional_name = getenv(ENV_TCP_BIND_NAME);
+	if (!env_optional_name) {
 		ruleset_attr.handled_access_net &=
 			~LANDLOCK_ACCESS_NET_BIND_TCP;
 	}
 	/* Removes connect access attribute if not supported by a user. */
-	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
-	if (!env_port_name) {
+	env_optional_name = getenv(ENV_TCP_CONNECT_NAME);
+	if (!env_optional_name) {
 		ruleset_attr.handled_access_net &=
 			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
 	}
-
+	/* Removes socket create access attribute if not supported by a user. */
+	env_optional_name = getenv(ENV_SOCKET_CREATE_NAME);
+	if (!env_optional_name) {
+		ruleset_attr.handled_access_socket &=
+			~LANDLOCK_ACCESS_SOCKET_CREATE;
+	}
 	ruleset_fd =
 		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
 	if (ruleset_fd < 0) {
@@ -373,6 +491,11 @@ int main(const int argc, char *const argv[], char *const *const envp)
 		goto err_close_ruleset;
 	}
 
+	if (populate_ruleset_socket(ENV_SOCKET_CREATE_NAME, ruleset_fd,
+				 LANDLOCK_ACCESS_SOCKET_CREATE)) {
+		goto err_close_ruleset;
+	}
+
 	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
 		perror("Failed to restrict privileges");
 		goto err_close_ruleset;
-- 
2.34.1

