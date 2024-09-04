Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534871D3195;
	Wed,  4 Sep 2024 10:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446948; cv=none; b=t2A2ze/Ja85Y9lODofxDGb+OFJJ3xQ6KtLGVi4XRzmh943AM6H+9h/M0W18XYWu8POmoCNBSjvzVGzzwQinW5rLvbAk/PzDA7yCAXynwQJFD+dlM2y6hhs3xCk57YTNfZb9n7HCtZoabfRLybrTda2pDTDjqk8eOSC8wM8tsKZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446948; c=relaxed/simple;
	bh=MnTVEv0OPDyrBu53ehWhbTDD7SNVHBcs646S3Eq1vZQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pPGZ06Ei4+tPhGYpztZIkjF+JXlnLxjQHx0mySGKh7/xUHxAXsU4HcKIyCP+AuGVxqQA7J0etGWB9Oo6asJfSoHYIkErkpvZqqW5iIvf77aa0cnBTHBBrMLeTNmlMkr9EaF0xIP1ox5LsFDboQaLOCVuYmjBKyjDAbK4mjrL14I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WzK2t60T6zyQyK;
	Wed,  4 Sep 2024 18:48:06 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 807671400CA;
	Wed,  4 Sep 2024 18:49:04 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:49:02 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 18/19] samples/landlock: Support socket protocol restrictions
Date: Wed, 4 Sep 2024 18:48:23 +0800
Message-ID: <20240904104824.1844082-19-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Add socket protocol control support in sandboxer demo. It's possible
to allow a sandboxer to create sockets with specified family and type
values. This is controlled with the new LL_SOCKET_CREATE environment
variable. Single token in this variable looks like this:
'FAMILY.TYPE', where FAMILY and TYPE are integers corresponding to the
number of address family and socket type.

Add parse_socket_protocol() method to parse socket family and type
strings into integers.

Change LANDLOCK_ABI_LAST to 6.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v2:
* Changes representation of socket protocol in LL_SOCKET_CREATE into
  pair of integer values.
* Changes commit message.
* Minor fixes.

Changes since v1:
* Refactors get_socket_protocol(). Rename it to parse_socket_protocol().
* Changes LANDLOCK_ABI_LAST to 6 since ioctl patchlist updated it to 5.
* Refactors commit message.
* Formats with clang-format.
* Minor changes.
---
 samples/landlock/sandboxer.c | 108 ++++++++++++++++++++++++++++++-----
 1 file changed, 95 insertions(+), 13 deletions(-)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index d4dba9e4ce89..1669095f9373 100644
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
@@ -209,6 +213,65 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 	return ret;
 }
 
+static int populate_ruleset_socket(const char *const env_var,
+				   const int ruleset_fd,
+				   const __u64 allowed_access)
+{
+	int ret = 1;
+	char *env_protocol_name, *strprotocol, *strfamily, *strtype;
+	unsigned long long family_ull, type_ull;
+	struct landlock_socket_attr protocol = {
+		.allowed_access = allowed_access,
+	};
+
+	env_protocol_name = getenv(env_var);
+	if (!env_protocol_name)
+		return 0;
+	env_protocol_name = strdup(env_protocol_name);
+	unsetenv(env_var);
+
+	while ((strprotocol = strsep(&env_protocol_name, ENV_DELIMITER))) {
+		strfamily = strsep(&strprotocol, ENV_TOKEN_INTERNAL_DELIMITER);
+		strtype = strsep(&strprotocol, ENV_TOKEN_INTERNAL_DELIMITER);
+
+		if (!strtype) {
+			fprintf(stderr,
+				"Failed to extract socket protocol with "
+				"unspecified type value\n");
+			goto out_free_name;
+		}
+
+		if (str2num(strfamily, &family_ull)) {
+			fprintf(stderr,
+				"Failed to convert \"%s\" into a number\n",
+				strfamily);
+			goto out_free_name;
+		}
+		if (str2num(strtype, &type_ull)) {
+			fprintf(stderr,
+				"Failed to convert \"%s\" into a number\n",
+				strtype);
+			goto out_free_name;
+		}
+		protocol.family = (int)family_ull;
+		protocol.type = (int)type_ull;
+
+		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				      &protocol, 0)) {
+			fprintf(stderr,
+				"Failed to update the ruleset with "
+				"family \"%s\" and type \"%s\": %s\n",
+				strfamily, strtype, strerror(errno));
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
@@ -233,14 +296,14 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 
 /* clang-format on */
 
-#define LANDLOCK_ABI_LAST 5
+#define LANDLOCK_ABI_LAST 6
 
 int main(const int argc, char *const argv[], char *const *const envp)
 {
 	const char *cmd_path;
 	char *const *cmd_argv;
 	int ruleset_fd, abi;
-	char *env_port_name;
+	char *env_optional_name;
 	__u64 access_fs_ro = ACCESS_FS_ROUGHLY_READ,
 	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE;
 
@@ -248,18 +311,19 @@ int main(const int argc, char *const argv[], char *const *const envp)
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
@@ -268,7 +332,7 @@ int main(const int argc, char *const argv[], char *const *const envp)
 			"* %s: list of paths allowed to be used in a read-write way.\n\n",
 			ENV_FS_RW_NAME);
 		fprintf(stderr,
-			"Environment variables containing ports are optional "
+			"Environment variables containing ports or protocols are optional "
 			"and could be skipped.\n");
 		fprintf(stderr,
 			"* %s: list of ports allowed to bind (server).\n",
@@ -276,15 +340,19 @@ int main(const int argc, char *const argv[], char *const *const envp)
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
+			"%s=\"10.2:1.1\" "
 			"%s bash -i\n\n",
 			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
-			ENV_TCP_CONNECT_NAME, argv[0]);
+			ENV_TCP_CONNECT_NAME, ENV_SOCKET_CREATE_NAME, argv[0]);
 		fprintf(stderr,
 			"This sandboxer can use Landlock features "
 			"up to ABI version %d.\n",
@@ -351,7 +419,11 @@ int main(const int argc, char *const argv[], char *const *const envp)
 	case 4:
 		/* Removes LANDLOCK_ACCESS_FS_IOCTL_DEV for ABI < 5 */
 		ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_IOCTL_DEV;
-
+		__attribute__((fallthrough));
+	case 5:
+		/* Removes socket support for ABI < 6 */
+		ruleset_attr.handled_access_socket &=
+			~LANDLOCK_ACCESS_SOCKET_CREATE;
 		fprintf(stderr,
 			"Hint: You should update the running kernel "
 			"to leverage Landlock features "
@@ -371,18 +443,23 @@ int main(const int argc, char *const argv[], char *const *const envp)
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
@@ -406,6 +483,11 @@ int main(const int argc, char *const argv[], char *const *const envp)
 		goto err_close_ruleset;
 	}
 
+	if (populate_ruleset_socket(ENV_SOCKET_CREATE_NAME, ruleset_fd,
+				    LANDLOCK_ACCESS_SOCKET_CREATE)) {
+		goto err_close_ruleset;
+	}
+
 	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
 		perror("Failed to restrict privileges");
 		goto err_close_ruleset;
-- 
2.34.1

