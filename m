Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ubf1S4T+"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA59BC4
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4TkhuKzb/wjlUvntsy6XWtLJ7Js6pu8c3kPwgNifcUM=; b=Ubf1S4T+HpU1zScNta80nKEpOL
	1hQJQMB8iYb7g7oomQvSjMGm2dmDI4d4mvhOSgAqjnhG/0wvVxPLpPSdjtYeuqR2XXdRqSFypiNLU
	py6XY+Ja9yzKsZJvirRyqYa8A0UFSzfBYQ5ijo5nIThZPK1A79OcaHTlP8uTftxP/nsh3Be8Os7/b
	5F5JSkOYbpIZQm5euJH5ofjvVg2sYteVha5QZifxnic+Q1L/mTct1SsAbl+yh0ywdTU3Rv+uGoMz+
	65D+299LpF3vbA3LehhroLewuvxAb1lOq3T7ino4bz7pQ5+9osgZnwEs155cK1KFrskQQIT8kodbM
	qdfNDcSQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPi-0001iy-5J
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/13] ebtables: Make 'h' case just a call to print_help()
Date: Wed, 29 Nov 2023 14:28:24 +0100
Message-ID: <20231129132827.18166-11-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the special ebtables help parameter handling into its print_help()
function to prepare for it turning into a callback. Add new field 'argc'
to struct iptables_command_state to make this possible. It is actually
kind of consistent as it holds 'argv' already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.h    |  1 +
 iptables/xtables-eb.c | 61 +++++++++++++++++++++----------------------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index 68acfb4b406fb..de32198fa0b67 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -137,6 +137,7 @@ struct iptables_command_state {
 	char *protocol;
 	int proto_used;
 	const char *jumpto;
+	int argc;
 	char **argv;
 	bool restore;
 };
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 017e1ad364840..8ab479237faa8 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -308,6 +308,33 @@ static void print_help(struct iptables_command_state *cs)
 	const struct xtables_rule_match *m = cs->matches;
 	struct xtables_target *t = cs->target;
 
+	while (optind < cs->argc) {
+		/*struct ebt_u_match *m;
+		struct ebt_u_watcher *w;*/
+
+		if (!strcasecmp("list_extensions", cs->argv[optind])) {
+			ebt_list_extensions(xtables_targets, cs->matches);
+			exit(0);
+		}
+		/*if ((m = ebt_find_match(cs->argv[optind])))
+			ebt_add_match(new_entry, m);
+		else if ((w = ebt_find_watcher(cs->argv[optind])))
+			ebt_add_watcher(new_entry, w);
+		else {*/
+			if (!(t = xtables_find_target(cs->argv[optind],
+						      XTF_TRY_LOAD)))
+				xtables_error(PARAMETER_PROBLEM,
+					      "Extension '%s' not found",
+					      cs->argv[optind]);
+			if (cs->options & OPT_JUMP)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Sorry, you can only see help for one target extension at a time");
+			cs->options |= OPT_JUMP;
+			cs->target = t;
+		//}
+		optind++;
+	}
+
 	printf("%s %s\n", prog_name, prog_vers);
 	printf(
 "Usage:\n"
@@ -735,6 +762,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	unsigned int flags = 0;
 	struct xtables_target *t;
 	struct iptables_command_state cs = {
+		.argc = argc,
 		.argv = argv,
 		.jumpto	= "",
 		.eb.bitmask = EBT_NOPROTO,
@@ -897,32 +925,8 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			if (OPT_COMMANDS)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Multiple commands are not allowed");
-			command = 'h';
-
-			/* All other arguments should be extension names */
-			while (optind < argc) {
-				/*struct ebt_u_match *m;
-				struct ebt_u_watcher *w;*/
-
-				if (!strcasecmp("list_extensions", argv[optind])) {
-					ebt_list_extensions(xtables_targets, cs.matches);
-					exit(0);
-				}
-				/*if ((m = ebt_find_match(argv[optind])))
-					ebt_add_match(new_entry, m);
-				else if ((w = ebt_find_watcher(argv[optind])))
-					ebt_add_watcher(new_entry, w);
-				else {*/
-					if (!(t = xtables_find_target(argv[optind], XTF_TRY_LOAD)))
-						xtables_error(PARAMETER_PROBLEM,"Extension '%s' not found", argv[optind]);
-					if (flags & OPT_JUMP)
-						xtables_error(PARAMETER_PROBLEM,"Sorry, you can only see help for one target extension at a time");
-					flags |= OPT_JUMP;
-					cs.target = t;
-				//}
-				optind++;
-			}
-			break;
+			print_help(&cs);
+			exit(0);
 		case 't': /* Table */
 			if (restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
@@ -1142,11 +1146,6 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	if (!(table = ebt_find_table(replace->name)))
 		ebt_print_error2("Bad table name");*/
 
-	if (command == 'h' && !(flags & OPT_ZERO)) {
-		print_help(&cs);
-		ret = 1;
-	}
-
 	/* Do the final checks */
 	if (command == 'A' || command == 'I' ||
 	    command == 'D' || command == 'C' || command == 14) {
-- 
2.41.0

