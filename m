From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] iptables 1.4.16.1 release
Date: Mon, 8 Oct 2012 01:51:36 +0200
Message-ID: <20121007235136.GA9874@1984>
References: <20121007231706.GA7400@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+g7M9IMkV8truYOl"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52146 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab2JGXvp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:51:45 -0400
Content-Disposition: inline
In-Reply-To: <20121007231706.GA7400@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 08, 2012 at 01:17:06AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 08, 2012 at 12:24:41AM +0200, Pablo Neira Ayuso wrote:
> Hi!
> 
> The Netfilter project proudly presents:
> 
>         iptables 1.4.16.1
> 
> This release fixes a major breakage introduced by:
> 
> commit cd2f9bdbb7f9b737e5d640aafeb78bcd8e3a7adf
> Author: Jan Engelhardt <jengelh@inai.de>
> Date:   Tue Sep 4 05:24:47 2012 +0200
> 
>     iptables: support for target aliases
> 
> This is really unfortunate, it seems this patch has been pushed
> mainstream without sufficient testing. We are really sorry for the
> inconvenience. Please, don't use 1.4.16, this bug reders it
> completely useless.
> 
> See ChangeLog that comes attached to this email for more details.

I got everything working back but the new target alias infrastructure
while rushing to fix the breakage.

The patch attached should get the target aliasing working. This is not
serious though, the only target that can benefit from this is feature
is NOTRACK, and it will be removed in the upcoming 3.7, ie. there is
no kernel available that can benefit from this feature.

--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index faddb71..1683621 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1286,7 +1286,7 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	if (cs->target->real_name != NULL)
+	if (strcmp(cs->target->real_name, "standard") == 0)
 		strcpy(cs->target->t->u.user.name, cs->jumpto);
 	else
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 96cea64..ae22ead 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1295,7 +1295,7 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	if (cs->target->real_name != NULL)
+	if (strcmp(cs->target->real_name, "standard") == 0)
 		strcpy(cs->target->t->u.user.name, cs->jumpto);
 	else
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);

--+g7M9IMkV8truYOl--
