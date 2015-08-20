From: Andreas Herz <andi@geekosphere.org>
Subject: Re: ICMPv6 Type 1 Code 5 and 6 missing in iptables REJECT target and
 icmpv6 match
Date: Thu, 20 Aug 2015 11:21:26 +0200
Message-ID: <20150820092126.GS21654@kvmbude>
References: <20150819145136.GN21654@kvmbude>
 <alpine.LSU.2.20.1508201012310.28043@nerf40.vanv.qr>
 <20150820090642.GR21654@kvmbude>
 <alpine.LSU.2.20.1508201112020.8021@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:38933 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbHTJV2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 05:21:28 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1508201112020.8021@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/08/15 at 11:16, Jan Engelhardt wrote:
> 
> On Thursday 2015-08-20 11:06, Andreas Herz wrote:
> >
> >I just tested around and icmpv6 is already working but that's caused by
> >rather optimistic parsing:
> >
> >> if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
> >
> >So --icmpv6-type 1/255 is also possible.
> 
> Specifying raw numbers for packet fields should always be possible, 
> exactly because some local name mapping database may be out of date or 
> because new things get invented at IETF over time.

Sounds reasonable, so i will just add the names. Thanks for the
explanation. The icmpv6 match was just something i looked into while i
saw the issue with REJECT. So small patch incoming.

> However, since you are concerned about the REJECT target, and 
> --reject-with takes a mnemonic that is only used to communicate with the 
> kernel module, rather than a value that is directly placed into a 
> network packet, the above would not apply.

And i don't even have a chance to "cheat" (as i can with the raw numbers
in the icmpv6 match) so i will work on that part to add those codes.

-- 
Andreas Herz
