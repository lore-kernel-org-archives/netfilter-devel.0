Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TezizLDa"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6434010D4
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KxUdjGCe4vJwoieDwFtcWCGbhastKXhd3wwPrafRJps=; b=TezizLDaDGp/j+zJXRMZoX+vEZ
	tjWQK7IHl7DrBh3tT+LNBnHTpqltiSyyYc4vTelE9jLRMUAzCj0ddYfdSbVdvIMD21ad7ZkDgJ5nS
	lf8YdDgGarw2C/4T4BDVSgdmKvQxPY2C/FX9k2FFhddGt37gjx7+evgRxFAAdy+OunMC6FPXQ1XTz
	ZlbOQJ8Is2VBinP6hlEsMqyrs14Ddk3W+5E7lqaX72JNbRbZSRWy2MHjJ47B/cJ2l5asmjw85iyFw
	mfsBXNXhoCMWbqQQ+dRQD4U+Luu4WVigdncJx4dlyucgNFCg1EaLAYs3El54FQi07JRTNsfbgRAqI
	VNsStxaA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPl-0001jb-PI
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/13] ebtables: Change option values to avoid clashes
Date: Wed, 29 Nov 2023 14:28:22 +0100
Message-ID: <20231129132827.18166-9-phil@nwl.cc>
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

In order to parse input using do_parse(), distinct ebtables option's
values have to be distinct from others. Since arptables uses values 2-8
already, resort to values >10.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb-translate.c | 14 +++++++-------
 iptables/xtables-eb.c           | 24 ++++++++++++------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index d0fec9c6d5ae3..a2ab318cff251 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -292,9 +292,9 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 			table_set = true;
 			break;
 		case 'i': /* Input interface */
-		case 2  : /* Logical input interface */
+		case 15 : /* Logical input interface */
 		case 'o': /* Output interface */
-		case 3  : /* Logical output interface */
+		case 16 : /* Logical output interface */
 		case 'j': /* Target */
 		case 'p': /* Net family protocol */
 		case 's': /* Source mac */
@@ -316,7 +316,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 
 				ebtables_parse_interface(optarg, cs.eb.in);
 				break;
-			} else if (c == 2) {
+			} else if (c == 15) {
 				ebt_check_option2(&flags, OPT_LOGICALIN);
 				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
 					xtables_error(PARAMETER_PROBLEM,
@@ -336,7 +336,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 
 				ebtables_parse_interface(optarg, cs.eb.out);
 				break;
-			} else if (c == 3) {
+			} else if (c == 16) {
 				ebt_check_option2(&flags, OPT_LOGICALOUT);
 				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
 					xtables_error(PARAMETER_PROBLEM,
@@ -424,14 +424,14 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 				xtables_error(PARAMETER_PROBLEM,
 					      "Sorry, protocols have values above or equal to 0x0600");
 			break;
-		case 4  : /* Lc */
+		case 17 : /* Lc */
 			ebt_check_option2(&flags, LIST_C);
 			if (command != 'L')
 				xtables_error(PARAMETER_PROBLEM,
 					      "Use --Lc with -L");
 			flags |= LIST_C;
 			break;
-		case 5  : /* Ln */
+		case 18 : /* Ln */
 			ebt_check_option2(&flags, LIST_N);
 			if (command != 'L')
 				xtables_error(PARAMETER_PROBLEM,
@@ -441,7 +441,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 					      "--Lx is not compatible with --Ln");
 			flags |= LIST_N;
 			break;
-		case 6  : /* Lx */
+		case 19 : /* Lx */
 			ebt_check_option2(&flags, LIST_X);
 			if (command != 'L')
 				xtables_error(PARAMETER_PROBLEM,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index db75e65caa02a..9afaa614bac5b 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -196,17 +196,17 @@ struct option ebt_original_options[] =
 	{ "insert"         , required_argument, 0, 'I' },
 	{ "delete"         , required_argument, 0, 'D' },
 	{ "list"           , optional_argument, 0, 'L' },
-	{ "Lc"             , no_argument      , 0, 4   },
-	{ "Ln"             , no_argument      , 0, 5   },
-	{ "Lx"             , no_argument      , 0, 6   },
+	{ "Lc"             , no_argument      , 0, 17  },
+	{ "Ln"             , no_argument      , 0, 18  },
+	{ "Lx"             , no_argument      , 0, 19  },
 	{ "Lmac2"          , no_argument      , 0, 12  },
 	{ "zero"           , optional_argument, 0, 'Z' },
 	{ "flush"          , optional_argument, 0, 'F' },
 	{ "policy"         , required_argument, 0, 'P' },
 	{ "in-interface"   , required_argument, 0, 'i' },
 	{ "in-if"          , required_argument, 0, 'i' },
-	{ "logical-in"     , required_argument, 0, 2   },
-	{ "logical-out"    , required_argument, 0, 3   },
+	{ "logical-in"     , required_argument, 0, 15  },
+	{ "logical-out"    , required_argument, 0, 16  },
 	{ "out-interface"  , required_argument, 0, 'o' },
 	{ "out-if"         , required_argument, 0, 'o' },
 	{ "version"        , no_argument      , 0, 'V' },
@@ -940,9 +940,9 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			table_set = true;
 			break;
 		case 'i': /* Input interface */
-		case 2  : /* Logical input interface */
+		case 15 : /* Logical input interface */
 		case 'o': /* Output interface */
-		case 3  : /* Logical output interface */
+		case 16 : /* Logical output interface */
 		case 'j': /* Target */
 		case 'p': /* Net family protocol */
 		case 's': /* Source mac */
@@ -965,7 +965,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 
 				ebtables_parse_interface(optarg, cs.eb.in);
 				break;
-			} else if (c == 2) {
+			} else if (c == 15) {
 				ebt_check_option2(&flags, OPT_LOGICALIN);
 				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
 					xtables_error(PARAMETER_PROBLEM,
@@ -985,7 +985,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 
 				ebtables_parse_interface(optarg, cs.eb.out);
 				break;
-			} else if (c == 3) {
+			} else if (c == 16) {
 				ebt_check_option2(&flags, OPT_LOGICALOUT);
 				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
 					xtables_error(PARAMETER_PROBLEM,
@@ -1073,14 +1073,14 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					      "Sorry, protocols have values above or equal to 0x0600");
 			break;
-		case 4  : /* Lc */
+		case 17 : /* Lc */
 			ebt_check_option2(&flags, LIST_C);
 			if (command != 'L')
 				xtables_error(PARAMETER_PROBLEM,
 					      "Use --Lc with -L");
 			flags |= LIST_C;
 			break;
-		case 5  : /* Ln */
+		case 18 : /* Ln */
 			ebt_check_option2(&flags, LIST_N);
 			if (command != 'L')
 				xtables_error(PARAMETER_PROBLEM,
@@ -1090,7 +1090,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 					      "--Lx is not compatible with --Ln");
 			flags |= LIST_N;
 			break;
-		case 6  : /* Lx */
+		case 19 : /* Lx */
 			ebt_check_option2(&flags, LIST_X);
 			if (command != 'L')
 				xtables_error(PARAMETER_PROBLEM,
-- 
2.41.0

