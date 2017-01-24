From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH] netfilter: nf_ct_helper: warn when not applying default
 helper assignment (was Re: [RFC PATCH 0/2] restore original default of
 nf_conntrack_helper sysctl)
Date: Tue, 24 Jan 2017 08:40:34 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm> <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com> <20170124012859.GA6375@salvia>
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
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60779 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdAXHxy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 02:53:54 -0500
In-Reply-To: <20170124012859.GA6375@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 23 Jan 2017, Linus Torvalds wrote:

> For all I know, there may be some security reason why we really don't
> want the automatic helpers, even if they can be convenient.
> 
> Also, you can just enable them with a kernel command line or a sysctl,
> so it's not like you can't get the old behavior back.

Yeah, the only concern really is causing instant breakage of existing 
firewall configurations just by upgrading the kernel.

On Tue, 24 Jan 2017, Pablo Neira Ayuso wrote:

> Yes, with helper modules in place, this is known to allow attackers to
> push holes in your firewall.  Eric Leblond actually show that it's
> perfectly feasible to exploit this via handcrafted packets [1]. The
> problem is documented here [2].
> 
> > Also, you can just enable them with a kernel command line or a sysctl,
> > so it's not like you can't get the old behavior back.
> 
> Right.
> 
> [1] https://cansecwest.com/csw12/conntrack-attack.pdf
> [2] https://home.regit.org/netfilter-en/secure-use-of-helpers/

Alright, that's a valid reason.

Still, I'd like us to be as helpful as possible when we really have no 
other choice than breaking existing userspace setup.

So how about issuing a warning in case we'd normally perform the automatic 
helper assignment, but we actually don't due to the new default setting? 
The fact that we've had the 'deprecated' warning there since 3.5 is nice, 
but let's face it -- that's not where the poor guy would be debugging why 
his firewall doesn't work. It'd be the kernel with the new default, and 
that doesn't give any hints whatsoever.



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

Re-use the 'net->ct.auto_assign_helper_warned' flag, as it'd be sufficient 
to warn one way or the other.

[1] https://cansecwest.com/csw12/conntrack-attack.pdf
[2] https://home.regit.org/netfilter-en/secure-use-of-helpers/

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 net/netfilter/nf_conntrack_helper.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 7341adf..02a26b0 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -213,17 +213,28 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	}
 
 	help = nfct_help(ct);
-	if (net->ct.sysctl_auto_assign_helper && helper == NULL) {
-		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-		if (unlikely(!net->ct.auto_assign_helper_warned && helper)) {
+	if (!helper)
+	{
+		if (__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple) &&
+				!net->ct.sysctl_auto_assign_helper &&
+				!net->ct.auto_assign_helper_warned) {
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

