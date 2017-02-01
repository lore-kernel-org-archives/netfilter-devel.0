From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH v3] netfilter: nf_ct_helper: warn when not applying default
 helper assignment
Date: Wed, 1 Feb 2017 21:01:54 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1702012057560.4763@cbobk.fhfr.pm>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm> <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com> <20170124012859.GA6375@salvia> <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm> <alpine.LSU.2.20.1701241115050.25515@cbobk.fhfr.pm>
 <CA+55aFxiM=GscZtvGkWnSfo3L4MTK0J6OFR5VbisZ1feTCBW9g@mail.gmail.com> <alpine.LSU.2.20.1701252136460.25515@cbobk.fhfr.pm> <20170201162704.GA3880@salvia> <alpine.LSU.2.20.1702012036110.4763@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz, eric@regit.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.20.1702012036110.4763@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Commit 3bb398d925 ("netfilter: nf_ct_helper: disable automatic helper 
assignment") is causing behavior regressions in firewalls, as traffic 
handled by conntrack helpers is now by default not passed through even 
though it was before due to missing CT targets (which were not necessary 
before this commit).

The default had to be switched off due to security reasons [1] [2] and 
therefore should stay the way it is, but let's be friendly to firewall 
admins and issue a warning the first time we're in situation where packet 
would be likely passed through with the old default but we're likely going 
to drop it on the floor now.

Rewrite the code a little bit as suggested by Linus, so that we avoid 
spaghettiing the code even more -- namely the whole decision making 
process regarding helper selection (either automatic or not) is being 
separated, so that the whole logic can be simplified and code (condition) 
duplication reduced.

[1] https://cansecwest.com/csw12/conntrack-attack.pdf
[2] https://home.regit.org/netfilter-en/secure-use-of-helpers/

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 net/netfilter/nf_conntrack_helper.c | 38 ++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 7341adf..3457456 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -188,6 +188,25 @@ struct nf_conn_help *
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 
+static struct nf_conntrack_helper *nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
+{
+	if (!net->ct.sysctl_auto_assign_helper) {
+		if (net->ct.auto_assign_helper_warned)
+			return NULL;
+		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
+			return NULL;
+		pr_info("nf_conntrack: default automatic helper assignment "
+			"has been turned off for security reasons and CT-based "
+			" firewall rule not found. Use the iptables CT target "
+			"to attach helpers instead.\n");
+		net->ct.auto_assign_helper_warned = 1;
+		return NULL;
+	}
+
+	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+}
+
+
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags)
 {
@@ -213,21 +232,14 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	}
 
 	help = nfct_help(ct);
-	if (net->ct.sysctl_auto_assign_helper && helper == NULL) {
-		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-		if (unlikely(!net->ct.auto_assign_helper_warned && helper)) {
-			pr_info("nf_conntrack: automatic helper "
-				"assignment is deprecated and it will "
-				"be removed soon. Use the iptables CT target "
-				"to attach helpers instead.\n");
-			net->ct.auto_assign_helper_warned = true;
-		}
-	}
 
 	if (helper == NULL) {
-		if (help)
-			RCU_INIT_POINTER(help->helper, NULL);
-		return 0;
+		helper = nf_ct_lookup_helper(ct, net);
+		if (helper == NULL) {
+			if (help)
+				RCU_INIT_POINTER(help->helper, NULL);
+			return 0;
+		}
 	}
 
 	if (help == NULL) {
-- 
Jiri Kosina
SUSE Labs
