From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Fri, 16 Jul 2010 14:31:22 +0300
Message-ID: <1279279882.1603.56.camel@powerslave>
References: <1279278635.1603.53.camel@powerslave>
	 <alpine.LSU.2.01.1007161320310.14608@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "kaber@trash.net" <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: ext Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22961 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965018Ab0GPLbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:31:41 -0400
In-Reply-To: <alpine.LSU.2.01.1007161320310.14608@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2010-07-16 at 13:20 +0200, ext Jan Engelhardt wrote:
> On Friday 2010-07-16 13:10, Luciano Coelho wrote:
> >Jan Engelhardt <jengelh@medozas.de> writes:
> >> On Thursday 2010-04-22 13:14, Patrick McHardy wrote:
> >> 
> >> > This looks better, thanks. A few remaining questions about things
> >> > I missed previously:
> >> 
> >> Will deal with it shortly.
> >
> >Are you planning to resend this patch with the changes Patrick
> >suggested?
> 
> I can try.

Cool, thanks!


> >As you may have seen in my earlier rfc email, I'm interested in
> >something similar to the condition match.  I'm not sure whether the best
> >approach is to create a CONDITION target where we can set the condition
> >variable in the iptables itself or if it is better to create a new
> >"variable match" and an accompanying "VARIABLE target" that keeps the
> >variables in memory, instead of using procfs.
> 
> procfs is in memory :)

Yes, of course, but I meant without exporting it to procfs. ;) That
would probably make the code a lot simpler (actually I can't imagine a
simpler match/target than a "variable" match/target ;)


-- 
Cheers,
Luca.

