Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2C5357A41;
	Tue, 18 Nov 2025 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473637; cv=none; b=CL/DlwgRK4Dk+dox+NGaqzl1X7XyWtkhjkEz2xIFzaIjKZAPivJr0jBduzkqOXRbVeQZQ+aXbDrRquoN3zM+Fl8uEkw5tWqIes3Wt+K/MkJ1A2WXF7cBJnhjtO4+MMEZZWk1Zr6KLlu6ONjz0/3qMsLDL1/HkgDTN8ZNZ9Wlpqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473637; c=relaxed/simple;
	bh=V1yp+BUR1YEr6m4+ySFm5hgmbECt3sGOawI0lGZtLfM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtBVMKr5TauIFvBVQS/CiQBKY3dPH6mO35o6hLrec8ybqEs0KV+/fWlGD3taLqSN8Rh4jFTHLRVRuu88vk4Y2Jq42H/mnMhkLL8ygh+sayOicegsIJn71MzYsy260v1wzQW6sH6kHBkEuhtNLyAYnwCZ9QSaLMw8T4g/JhUA/EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9X5gfpzJ46dP;
	Tue, 18 Nov 2025 21:46:24 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D4811402F3;
	Tue, 18 Nov 2025 21:47:07 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:06 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 18/19] samples/landlock: Support socket protocol restrictions
Date: Tue, 18 Nov 2025 21:46:38 +0800
Message-ID: <20251118134639.3314803-19-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Add socket protocol control support in sandboxer demo. It's possible
to allow a sandboxer to create sockets with specified family and type
values. This is controlled with the new LL_SOCKET_CREATE environment
variable. Single token in this variable looks like this:
'{family}.{type}.{protocol}', where {family}, {type} and {protocol} are
integers corresponding to requested protocol definition.

Change LANDLOCK_ABI_LAST to 8.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Changes ABI from 6 to 8.
* Adds protocol field support.
* Fixes commit message.
* Minor fixes.

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
 samples/landlock/sandboxer.c | 118 ++++++++++++++++++++++++++++++++---
 1 file changed, 109 insertions(+), 9 deletions(-)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index e7af02f98208..96930c505807 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -60,9 +60,11 @@ static inline int landlock_restrict_self(const int ruleset_fd,
 #define ENV_FS_RW_NAME "LL_FS_RW"
 #define ENV_TCP_BIND_NAME "LL_TCP_BIND"
 #define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
+#define ENV_SOCKET_CREATE_NAME "LL_SOCKET_CREATE"
 #define ENV_SCOPED_NAME "LL_SCOPED"
 #define ENV_FORCE_LOG_NAME "LL_FORCE_LOG"
 #define ENV_DELIMITER ":"
+#define ENV_TOKEN_INTERNAL_DELIMITER "."
 
 static int str2num(const char *numstr, __u64 *num_dst)
 {
@@ -226,6 +228,83 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 	return ret;
 }
 
+static int populate_ruleset_socket(const char *const env_var,
+				   const int ruleset_fd,
+				   const __u64 allowed_access)
+{
+	int ret = 1;
+	char *env_protocol_name, *strprotocol, *strfamily, *strtype, *strproto;
+	unsigned long long family_ull, type_ull, proto_ull;
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
+		strproto = strsep(&strprotocol, ENV_TOKEN_INTERNAL_DELIMITER);
+
+		/* strsep should make this NULL if it had less than two delimiters. */
+		if (strprotocol) {
+			fprintf(stderr, "Invalid format of socket protocol\n");
+			goto out_free_name;
+		}
+		if (!strtype) {
+			fprintf(stderr,
+				"Failed to extract socket protocol with "
+				"unspecified type value\n");
+			goto out_free_name;
+		} else if (!strproto) {
+			fprintf(stderr,
+				"Failed to extract socket protocol with "
+				"unspecified protocol value\n");
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
+		if (str2num(strproto, &proto_ull)) {
+			fprintf(stderr,
+				"Failed to convert \"%s\" into a number\n",
+				strproto);
+			goto out_free_name;
+		}
+		protocol.family = (int)family_ull;
+		protocol.type = (int)type_ull;
+		protocol.protocol = (int)proto_ull;
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
 /* Returns true on error, false otherwise. */
 static bool check_ruleset_scope(const char *const env_var,
 				struct landlock_ruleset_attr *ruleset_attr)
@@ -299,7 +378,7 @@ static bool check_ruleset_scope(const char *const env_var,
 
 /* clang-format on */
 
-#define LANDLOCK_ABI_LAST 7
+#define LANDLOCK_ABI_LAST 8
 
 #define XSTR(s) #s
 #define STR(s) XSTR(s)
@@ -311,7 +390,7 @@ static const char help[] =
 	"[other environment variables] %1$s <cmd> [args]...\n"
 	"\n"
 	"Execute the given command in a restricted environment.\n"
-	"Multi-valued settings (lists of ports, paths, scopes) are colon-delimited.\n"
+	"Multi-valued settings (lists of ports, paths, protocols, scopes) are colon-delimited.\n"
 	"\n"
 	"Mandatory settings:\n"
 	"* " ENV_FS_RO_NAME ": paths allowed to be used in a read-only way\n"
@@ -322,6 +401,9 @@ static const char help[] =
 	"means an empty list):\n"
 	"* " ENV_TCP_BIND_NAME ": ports allowed to bind (server)\n"
 	"* " ENV_TCP_CONNECT_NAME ": ports allowed to connect (client)\n"
+	"* " ENV_SOCKET_CREATE_NAME ": list of socket protocols allowed to be created\n"
+	"  To define protocol format \"{family}.{type}.{protocol}\" is used\n"
+	"  with numerical values of family, type and protocol (eg. 2.1.0 for TCP/IP)\n"
 	"* " ENV_SCOPED_NAME ": actions denied on the outside of the landlock domain\n"
 	"  - \"a\" to restrict opening abstract unix sockets\n"
 	"  - \"s\" to restrict sending signals\n"
@@ -334,6 +416,7 @@ static const char help[] =
 	ENV_FS_RW_NAME "=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
 	ENV_TCP_BIND_NAME "=\"9418\" "
 	ENV_TCP_CONNECT_NAME "=\"80:443\" "
+	ENV_SOCKET_CREATE_NAME "=\"2.1.0\" "
 	ENV_SCOPED_NAME "=\"a:s\" "
 	"%1$s bash -i\n"
 	"\n"
@@ -347,7 +430,7 @@ int main(const int argc, char *const argv[], char *const *const envp)
 	const char *cmd_path;
 	char *const *cmd_argv;
 	int ruleset_fd, abi;
-	char *env_port_name, *env_force_log;
+	char *env_opt_name, *env_force_log;
 	__u64 access_fs_ro = ACCESS_FS_ROUGHLY_READ,
 	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE;
 
@@ -355,6 +438,7 @@ int main(const int argc, char *const argv[], char *const *const envp)
 		.handled_access_fs = access_fs_rw,
 		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
 				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
 		.scoped = LANDLOCK_SCOPE_ABSTRACT_UNIX_SOCKET |
 			  LANDLOCK_SCOPE_SIGNAL,
 	};
@@ -437,6 +521,12 @@ int main(const int argc, char *const argv[], char *const *const envp)
 		supported_restrict_flags &=
 			~LANDLOCK_RESTRICT_SELF_LOG_NEW_EXEC_ON;
 
+		__attribute__((fallthrough));
+	case 7:
+		/* Removes LANDLOCK_ACCESS_SOCKET_CREATE for ABI < 8 */
+		ruleset_attr.handled_access_socket &=
+			~LANDLOCK_ACCESS_SOCKET_CREATE;
+
 		/* Must be printed for any ABI < LANDLOCK_ABI_LAST. */
 		fprintf(stderr,
 			"Hint: You should update the running kernel "
@@ -456,18 +546,24 @@ int main(const int argc, char *const argv[], char *const *const envp)
 	access_fs_ro &= ruleset_attr.handled_access_fs;
 	access_fs_rw &= ruleset_attr.handled_access_fs;
 
-	/* Removes bind access attribute if not supported by a user. */
-	env_port_name = getenv(ENV_TCP_BIND_NAME);
-	if (!env_port_name) {
+	/* Removes bind access attribute if not requested by a user. */
+	env_opt_name = getenv(ENV_TCP_BIND_NAME);
+	if (!env_opt_name) {
 		ruleset_attr.handled_access_net &=
 			~LANDLOCK_ACCESS_NET_BIND_TCP;
 	}
-	/* Removes connect access attribute if not supported by a user. */
-	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
-	if (!env_port_name) {
+	/* Removes connect access attribute if not requested by a user. */
+	env_opt_name = getenv(ENV_TCP_CONNECT_NAME);
+	if (!env_opt_name) {
 		ruleset_attr.handled_access_net &=
 			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
 	}
+	/* Removes socket creation access attribute if not requested by a user. */
+	env_opt_name = getenv(ENV_SOCKET_CREATE_NAME);
+	if (!env_opt_name) {
+		ruleset_attr.handled_access_socket &=
+			~LANDLOCK_ACCESS_SOCKET_CREATE;
+	}
 
 	if (check_ruleset_scope(ENV_SCOPED_NAME, &ruleset_attr))
 		return 1;
@@ -512,6 +608,10 @@ int main(const int argc, char *const argv[], char *const *const envp)
 				 LANDLOCK_ACCESS_NET_CONNECT_TCP)) {
 		goto err_close_ruleset;
 	}
+	if (populate_ruleset_socket(ENV_SOCKET_CREATE_NAME, ruleset_fd,
+				    LANDLOCK_ACCESS_SOCKET_CREATE)) {
+		goto err_close_ruleset;
+	}
 
 	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
 		perror("Failed to restrict privileges");
-- 
2.34.1

