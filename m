From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 00/69]: Netfilter Update
Date: Wed, 30 Jan 2008 22:27:31 +0100
Message-ID: <47A0EBC3.4000304@trash.net>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain> <Pine.LNX.4.64.0801302153450.3599@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62347 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYA3V2I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:28:08 -0500
In-Reply-To: <Pine.LNX.4.64.0801302153450.3599@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 30 2008 21:16, Patrick McHardy wrote:
>   
>> following is the final netfilter update for 2.6.25. containing the iptables
>> netns work by Alexey Dobriyan, lots of sparse warning fixes by Stephen, Eric
>> and myself, const annotations throughout netfilter by Jan Engelhardt,
>> a set of patches to finally use RCU for the conntrack and NAT hashes, some
>> conntrack optimizations and some minor misc cleanups.
>>     
>
> What do people use to apply this batch? I exported them into an MBOX
> and tried git-am, but that always uses the mail's From: and Subject:
> rather than the --raw patch after the three-dashes.
>   

I'll push my tree to netfilter.org, things are going pretty slow,
but it should appear at http://people.netfilter.org/~kaber/nf-2.6.git
within the next 30 minutes or so.


