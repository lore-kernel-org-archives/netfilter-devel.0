From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 27/27] Update feature-removal-schedule.txt
Date: Tue, 08 Jan 2008 17:33:17 +0100
Message-ID: <4783A5CD.4050705@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022134290.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64136 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYAHQhR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:37:17 -0500
In-Reply-To: <Pine.LNX.4.64.0801022134290.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +What (Why):
> +	- include/linux/netfilter_ipv4/ipt_TOS.h ipt_tos.h header files
> +	  (superseded by xt_TOS/xt_tos target & match)
> +
> +	- "forwarding" header files like ipt_mac.h in
> +	  include/linux/netfilter_ipv4/ and include/linux/netfilter_ipv6/
> +
> +	- xt_CONNMARK match revision 0
> +	  (superseded by xt_CONNMARK match revision 1)
> +
> +	- xt_MARK target revisions 0 and 1
> +	  (superseded by xt_MARK match revision 2)
> +
> +	- xt_connmark match revision 0
> +	  (superseded by xt_connmark match revision 1)
> +
> +	- xt_conntrack match revision 0
> +	  (superseded by xt_conntrack match revision 1)
> +
> +	- xt_hashlimit match revision 0
> +	  (superseded by xt_hashlimit match revision 1)
> +
> +	- xt_helper match revision 0
> +	  (superseded by xt_helper match revision 1)
> +
> +	- xt_iprange match revision 0,
> +	  include/linux/netfilter_ipv4/ipt_iprange.h
> +	  (superseded by xt_iprange match revision 1)
> +
> +	- xt_length match revision 0
> +	  (superseded by xt_length match revision 1)
> +
> +	- xt_mark match revision 0
> +	  (superseded by xt_mark match revision 1)
> +
> +	- xt_state match revision 0
> +	  (obsoleted by xt_conntrack match revision 1)


I removed xt_state, xt_length, xt_helper since I didn't apply those
patches yet and applied the patch.

Since I've lost the overview of your kernel patches I'm going to
stop at the ones I have now. Please resend everything relevant
once I've pushed my tree to Dave. Thanks.

I'll look into the userspace patches soon.
