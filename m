From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH v2] netfilter: nf_ct_helper: warn when not applying default
 helper assignment
Date: Tue, 24 Jan 2017 11:17:18 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701241115050.25515@cbobk.fhfr.pm>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm> <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com> <20170124012859.GA6375@salvia> <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz, eric@regit.org
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm>
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

Re-use the 'net->ct.auto_assign_helper_warned' flag, as it'd be sufficient
to warn one way or the other.

[1] https://cansecwest.com/csw12/conntrack-attack.pdf
[2] https://home.regit.org/netfilter-en/secure-use-of-helpers/

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

v1 -> v2: polished the condition; put unlikely() in place and reordered
	  so that we perform __nf_ct_helper_find() lookup only if we 
	  haven't warned before and the sysctl is unset

 net/netfilter/nf_conntrack_helper.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 7341adf..d82d5ee 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -213,17 +213,27 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	}
 
 	help = nfct_help(ct);
-	if (net->ct.sysctl_auto_assign_helper && helper == NULL) {
-		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-		if (unlikely(!net->ct.auto_assign_helper_warned && helper)) {
+	if (!helper) {
+		if (unlikely(!net->ct.sysctl_auto_assign_helper &&
+				!net->ct.auto_assign_helper_warned &&
+				__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))) {
+			pr_info("nf_conntrack: default automatic helper assignment "
+				"has been turned off for security reasons "
+				"and CT-based firewall rule not found. Use the "
+				"iptables CT target to attach helpers instead.\n");
+			net->ct.auto_assign_helper_warned = true;
+		} else {
+			helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+			if (unlikely(!net->ct.auto_assign_helper_warned && helper &&
+					!net->ct.auto_assign_helper_warned)) {
 			pr_info("nf_conntrack: automatic helper "
 				"assignment is deprecated and it will "
 				"be removed soon. Use the iptables CT target "
 				"to attach helpers instead.\n");
 			net->ct.auto_assign_helper_warned = true;
+			}
 		}
 	}
-
 	if (helper == NULL) {
 		if (help)
 			RCU_INIT_POINTER(help->helper, NULL);
-- 
Jiri Kosina
SUSE Labs
