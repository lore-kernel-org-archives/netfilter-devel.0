From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ICMPv6 Type 1 Code 5 and 6 missing in iptables REJECT target
 and icmpv6 match
Date: Thu, 20 Aug 2015 11:16:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1508201112020.8021@nerf40.vanv.qr>
References: <20150819145136.GN21654@kvmbude> <alpine.LSU.2.20.1508201012310.28043@nerf40.vanv.qr> <20150820090642.GR21654@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:54651 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbbHTJQn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 05:16:43 -0400
In-Reply-To: <20150820090642.GR21654@kvmbude>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2015-08-20 11:06, Andreas Herz wrote:
>
>I just tested around and icmpv6 is already working but that's caused by
>rather optimistic parsing:
>
>> if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
>
>So --icmpv6-type 1/255 is also possible.

Specifying raw numbers for packet fields should always be possible, 
exactly because some local name mapping database may be out of date or 
because new things get invented at IETF over time.

However, since you are concerned about the REJECT target, and 
--reject-with takes a mnemonic that is only used to communicate with the 
kernel module, rather than a value that is directly placed into a 
network packet, the above would not apply.
