From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: [NETFILTER 04/05]: nf_nat: always select same SNAT source for
 same host
Date: Tue, 13 Jan 2009 14:24:11 +0000 (UTC)
Message-ID: <gki86b$a4e$1@ger.gmane.org>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
 <20080227131432.26831.2125.sendpatchset@localhost.localdomain>
 <47C5907F.3060904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:38308 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbZAMOaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:30:07 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LMkHL-0006hL-41
	for netfilter-devel@vger.kernel.org; Tue, 13 Jan 2009 14:30:03 +0000
Received: from ppp-82-135-90-82.dynamic.mnet-online.de ([82.135.90.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2009 14:30:03 +0000
Received: from berni by ppp-82-135-90-82.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2009 14:30:03 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:

Hello Patrick,

> Patrick McHardy wrote:
>> [NETFILTER]: nf_nat: always select same SNAT source for same host
>> 
>> We've removed the SAME target in 2.6.25-rc since it had 32/64 bit compat
>> problems and the NAT core provides the same behaviour regarding IP
>> selection. This turned out to be not entirely correct though, the
>> NAT core only selects the same IP from a range for the same src,dst
>> combination. Some people need the same IP for all destinations however.
>> 
>> The easiest way to do this is to ignore the destination IP when
>> doing SNAT. Since we're using jhash, we still get good distribution
>> for multiple source IPs.
>> 
>> Tested-by: David Lau <mintypickle@gmail.com>
>> 
>> Signed-off-by: Patrick McHardy <kaber@trash.net>
>
>
> Please drop this patch for now, David reported some bad distribution
> during further tests that I want to look into.

Any news on that? We're getting hit by that issue (ICQ fails to login,
amongst others). In 2.6.25, but I did not see any patch in recent
kernels that changes this.

Bernhard

