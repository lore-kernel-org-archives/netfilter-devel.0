From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] NFQUEUE: add new v1 version with queue-balance
	option
Date: Fri, 5 Jun 2009 15:27:07 +0200
Message-ID: <20090605132707.GG29745@Chamillionaire.breakpoint.cc>
References: <1244164679-11032-1-git-send-email-fw@strlen.de> <1244164679-11032-3-git-send-email-fw@strlen.de> <alpine.LSU.2.00.0906051457160.17010@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58347 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbZFEN1G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:27:06 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0906051457160.17010@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> On Friday 2009-06-05 03:17, Florian Westphal wrote:
> >target4_v1{
> >+	.revision	= 1,
> >+	.name		= "NFQUEUE",
> >+	.version	= XTABLES_VERSION,
> >+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
> >+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
> >+	.help		= NFQUEUE_help_v1,
> >+	.init		= NFQUEUE_init_v1,
> >+	.parse		= NFQUEUE_parse_v1,
> >+	.print		= NFQUEUE_print_v1,
> >+	.save		= NFQUEUE_save_v1,
> >+	.extra_opts	= NFQUEUE_opts_v1,
> >+};
> >+
> >+static struct xtables_target nfqueue_target6_v1 = {
> >+	.family		= NFPROTO_IPV6,
> >+	.revision	= 1,
> 
> You can combine these two to NFPROTO_UNSPEC, like you did to v0,
> is not it?

Hm, v1 is tied to ipv4/6 on the kernel side, thats why I wanted to make
this explicit here, too.

> >--- a/extensions/libxt_NFQUEUE.man
> >+++ b/extensions/libxt_NFQUEUE.man
> >@@ -5,8 +5,18 @@ number.
> > \fB\-\-queue\-num\fP \fIvalue\fP
> > This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
> > .PP
> >+.TP
> >+\fB\-\-queue\-balance\fP \fIvalue\fP:\fIvalue\fP
> 
> Minor nitpick:  "\fIvalue\fP\fB:\fP\fIvale\fP", because the : is to
> be typed verbatim.

right, will fix.

> >+This specifies a range of queues to use. Packets are then balanced across the given queues.
> >+This is useful for multicore systems: start multiple instances of the userspace program on
> >+queues x, x+1, .. x+n and use "--queue-balance x:x+n".
> 
> \-\-queue\-balance here, too.

Doh -- I should have thought of that when typing this 8-/

> >+Packets belonging to the same connection are put into the same nfqueue.
> >+.PP
> > It can only be used with Kernel versions 2.6.14 or later, since it requires
> > the
> > .B
> > nfnetlink_queue
> > kernel support.
> >+.B
> >+queue-balance
> >+support was added in Linux 2.6.31.
> 
> Mh, try to use \fB...\fP, as that's somehow easier to recognize given
> people are familiar with HTML.
> 
> (\fBqueue-balance\fP support wa added in Linux 2.6.31.)

Agreed.
I will re-spin with these fixups after the 2.6.30 iptables release is out.

Thank you for reviewing this patch.
