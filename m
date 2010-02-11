From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/08: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
Date: Thu, 11 Feb 2010 08:39:38 +0100 (MET)
Message-ID: <20100211073935.7894.11114.sendpatchset@x2.localnet>
References: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35442 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab0BKHjj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 02:39:39 -0500
In-Reply-To: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 4e4aa88c264e9f8d013e3742e48a6bea37ca1c4c
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Feb 11 07:40:30 2010 +0100

    netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
    
    Make the output a bit more informative by showing the helper an expectation
    belongs to and the expectation class.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 9a2b9cb..917e170 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -66,6 +66,7 @@ static inline struct net *nf_ct_exp_net(struct nf_conntrack_expect *exp)
 struct nf_conntrack_expect_policy {
 	unsigned int	max_expected;
 	unsigned int	timeout;
+	const char	*name;
 };
 
 #define NF_CT_EXPECT_CLASS_DEFAULT	0
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 2f25ff6..33b85f8 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -500,6 +500,7 @@ static void exp_seq_stop(struct seq_file *seq, void *v)
 static int exp_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_expect *expect;
+	struct nf_conntrack_helper *helper;
 	struct hlist_node *n = v;
 	char *delim = "";
 
@@ -525,6 +526,14 @@ static int exp_seq_show(struct seq_file *s, void *v)
 	if (expect->flags & NF_CT_EXPECT_INACTIVE)
 		seq_printf(s, "%sINACTIVE", delim);
 
+	helper = rcu_dereference(nfct_help(expect->master)->helper);
+	if (helper) {
+		seq_printf(s, "%s%s", expect->flags ? " " : "", helper->name);
+		if (helper->expect_policy[expect->class].name)
+			seq_printf(s, "/%s",
+				   helper->expect_policy[expect->class].name);
+	}
+
 	return seq_putc(s, '\n');
 }
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 023966b..419c5ca 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1305,14 +1305,17 @@ static char sip_names[MAX_PORTS][2][sizeof("sip-65535")] __read_mostly;
 
 static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1] = {
 	[SIP_EXPECT_SIGNALLING] = {
+		.name		= "signalling",
 		.max_expected	= 1,
 		.timeout	= 3 * 60,
 	},
 	[SIP_EXPECT_AUDIO] = {
+		.name		= "audio",
 		.max_expected	= 2 * IP_CT_DIR_MAX,
 		.timeout	= 3 * 60,
 	},
 	[SIP_EXPECT_VIDEO] = {
+		.name		= "video",
 		.max_expected	= 2 * IP_CT_DIR_MAX,
 		.timeout	= 3 * 60,
 	},
