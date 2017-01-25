From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH v2] netfilter: nf_ct_helper: warn when not applying
 default helper assignment
Date: Wed, 25 Jan 2017 21:43:14 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701252136460.25515@cbobk.fhfr.pm>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm> <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com> <20170124012859.GA6375@salvia> <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm> <alpine.LSU.2.20.1701241115050.25515@cbobk.fhfr.pm>
 <CA+55aFxiM=GscZtvGkWnSfo3L4MTK0J6OFR5VbisZ1feTCBW9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz, eric@regit.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxiM=GscZtvGkWnSfo3L4MTK0J6OFR5VbisZ1feTCBW9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 25 Jan 2017, Linus Torvalds wrote:

> I don't disagree that this kind of warning might be useful, but that
> code makes my eyes bleed, and is really really hard to follow.

Yeah, I agree. Mea culpa for not keeping 'RFC' in subject for v2 still; I 
was mostly worried about the fact that neither Pablo nor you seemed to be 
concerned too much about the whole breakage, and hence I wanted to propose 
a compromise at least.

> Please make it a helper function.

So I ended up with the patch below. It's boot-and-sysctl-flip tested. As 
you've already come up with the identifiers for the lookup functions, I've 
retained those.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] netfilter: nf_ct_helper: warn when not applying default helper assignment

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

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 net/netfilter/nf_conntrack_helper.c | 58 +++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 7341adf..c93a331 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -188,6 +188,39 @@ struct nf_conn_help *
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 
+static struct nf_conntrack_helper *find_auto_helper(struct nf_conn *ct)
+{
+	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+}
+
+static struct nf_conntrack_helper *ct_lookup_helper(struct nf_conn *ct, struct net *net)
+{
+	struct nf_conntrack_helper *ret;
+
+	if (!net->ct.sysctl_auto_assign_helper) {
+		if (net->ct.auto_assign_helper_warned)
+			return NULL;
+		if (!find_auto_helper(ct))
+			return NULL;
+		pr_info("nf_conntrack: default automatic helper assignment "
+			"has been turned off for security reasons and CT-based "
+			" firewall rule not found. Use the iptables CT target "
+			"to attach helpers instead.\n");
+		net->ct.auto_assign_helper_warned = 1;
+		return NULL;
+	}
+
+	ret = find_auto_helper(ct);
+	if (!ret || net->ct.auto_assign_helper_warned)
+		return ret;
+	pr_info("nf_conntrack: automatic helper assignment is deprecated and it will "
+		"be removed soon. Use the iptables CT target to attach helpers "
+		" instead.\n");
+	net->ct.auto_assign_helper_warned = 1;
+	return ret;
+}
+
+
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags)
 {
@@ -213,26 +246,19 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
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
 
-	if (helper == NULL) {
-		if (help)
-			RCU_INIT_POINTER(help->helper, NULL);
-		return 0;
+	if (!helper) {
+		helper = ct_lookup_helper(ct, net);
+		if (!helper) {
+			if (help)
+				RCU_INIT_POINTER(help->helper, NULL);
+			return 0;
+		}
 	}
 
-	if (help == NULL) {
+	if (!help) {
 		help = nf_ct_helper_ext_add(ct, helper, flags);
-		if (help == NULL)
+		if (!help)
 			return -ENOMEM;
 	} else {
 		/* We only allow helper re-assignment of the same sort since

-- 
Jiri Kosina
SUSE Labs
