From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 2/2] src: add --check option flag
Date: Fri, 23 Jun 2017 18:38:25 +0200
Message-ID: <20170623163825.2066-2-pablombg@gmail.com>
References: <20170623163825.2066-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36114 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdFWQkV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2017 12:40:21 -0400
Received: by mail-wr0-f196.google.com with SMTP id 77so13766673wrb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2017 09:40:21 -0700 (PDT)
In-Reply-To: <20170623163825.2066-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sometimes it can be useful to test if a command is valid without
applying any change to the rule-set. This commit adds a new option
flag (-c | --check) that performs a dry run execution of the commands.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 doc/nft.xml        | 11 +++++++++++
 include/nftables.h |  1 +
 src/main.c         | 14 ++++++++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index e9ccd63..970acb5 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -52,6 +52,9 @@ vi:ts=4 sw=4
 				<option>-s | --stateless</option>
 			</arg>
 			<arg choice="opt">
+				<option>-c | --check</option>
+			</arg>
+			<arg choice="opt">
 				<option>[-I | --includepath]</option>
 				<replaceable>directory</replaceable>
 			</arg>
@@ -130,6 +133,14 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
+				<term><option>-c, --check</option></term>
+				<listitem>
+					<para>
+						Check commands validity without actually applying the changes.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
 				<term><option>-N</option></term>
 				<listitem>
 					<para>
diff --git a/include/nftables.h b/include/nftables.h
index dbd4637..26fd344 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -33,6 +33,7 @@ struct output_ctx {
 
 struct nft_ctx {
 	struct output_ctx	output;
+	bool			check;
 };
 
 extern unsigned int max_errors;
diff --git a/src/main.c b/src/main.c
index 16a01f3..849b3bf 100644
--- a/src/main.c
+++ b/src/main.c
@@ -40,6 +40,7 @@ static unsigned int num_include_paths = 1;
 enum opt_vals {
 	OPT_HELP		= 'h',
 	OPT_VERSION		= 'v',
+	OPT_CHECK		= 'c',
 	OPT_FILE		= 'f',
 	OPT_INTERACTIVE		= 'i',
 	OPT_INCLUDEPATH		= 'I',
@@ -51,7 +52,7 @@ enum opt_vals {
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvf:iI:vnsNa"
+#define OPTSTRING	"hvcf:iI:vnsNa"
 
 static const struct option options[] = {
 	{
@@ -63,6 +64,10 @@ static const struct option options[] = {
 		.val		= OPT_VERSION,
 	},
 	{
+		.name		= "check",
+		.val		= OPT_CHECK,
+	},
+	{
 		.name		= "file",
 		.val		= OPT_FILE,
 		.has_arg	= 1,
@@ -113,6 +118,7 @@ static void show_help(const char *name)
 "  -h, --help			Show this help\n"
 "  -v, --version			Show version information\n"
 "\n"
+"  -c --check			Check commands validity without actually applying the changes.\n"
 "  -f, --file <filename>		Read input from <filename>\n"
 "  -i, --interactive		Read input from interactive CLI\n"
 "\n"
@@ -202,7 +208,8 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs,
 		if (ret < 0)
 			goto out;
 	}
-	mnl_batch_end(batch);
+	if (!nft->check)
+		mnl_batch_end(batch);
 
 	if (!mnl_batch_ready(batch))
 		goto out;
@@ -278,6 +285,9 @@ int main(int argc, char * const *argv)
 			printf("%s v%s (%s)\n",
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
 			exit(NFT_EXIT_SUCCESS);
+		case OPT_CHECK:
+			nft.check = true;
+			break;
 		case OPT_FILE:
 			filename = optarg;
 			break;
-- 
2.11.0

