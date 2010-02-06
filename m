From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] xtables: symmetric COMPAT_XT_ALIGN definition
Date: Sat, 6 Feb 2010 08:30:15 +0200
Message-ID: <20100206063015.GA4129@x200>
References: <20100205221331.GC27953@x200>
 <alpine.LSU.2.01.1002060018530.32310@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:51579 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0BFGaR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Feb 2010 01:30:17 -0500
Received: by fxm20 with SMTP id 20so4769119fxm.1
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Feb 2010 22:30:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002060018530.32310@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 06, 2010 at 12:22:54AM +0100, Jan Engelhardt wrote:
> On Friday 2010-02-05 23:13, Alexey Dobriyan wrote:
> >@@ -514,7 +514,7 @@ int xt_check_target(struct xt_tgchk_param *par,
> > 		    unsigned int size, u_int8_t proto, bool inv_proto)
> > {
> > 	if (XT_ALIGN(par->target->targetsize) != size) {
> >-		pr_err("%s_tables: %s target: invalid size %Zu != %u\n",
> >+		pr_err("%s_tables: %s target: invalid size %u != %u\n",
> > 		       xt_prefix[par->family], par->target->name,
> > 		       XT_ALIGN(par->target->targetsize), size);
> > 		return -EINVAL;
> >@@ -364,7 +364,7 @@ int xt_check_match(struct xt_mtchk_param *par,
> > 		 * ebt_among is exempt from centralized matchsize checking
> > 		 * because it uses a dynamic-size data set.
> > 		 */
> >-		pr_err("%s_tables: %s match: invalid size %Zu != %u\n",
> >+		pr_err("%s_tables: %s match: invalid size %u != %u\n",
> > 		       xt_prefix[par->family], par->match->name,
> > 		       XT_ALIGN(par->match->matchsize), size);
> > 		return -EINVAL;
> 
> Why are you changing this? __alignof__ still returns a size_t,
> and this type promotes through the course of the ALIGN macro.

alignment is casted to the type of alignee, so it's unsigned int now:

	#define ALIGN(x,a) __ALIGN_MASK(x,(typeof(x))(a)-1)
