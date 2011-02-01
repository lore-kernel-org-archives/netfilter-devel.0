From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: ecache: always set events bits,	filter
 them later
Date: Tue, 01 Feb 2011 16:09:29 +0100
Message-ID: <4D482229.6000707@trash.net>
References: <20110201120116.3427.96097.stgit@decadence> <20110201120547.3427.21721.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43986 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1BAPJv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:09:51 -0500
In-Reply-To: <20110201120547.3427.21721.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 01.02.2011 13:05, schrieb Pablo Neira Ayuso:
> For the following rule:
> 
> iptables -I PREROUTING -t raw -j CT --ctevents assured
> 
> The event delivered looks like the following:
> 
>  [UPDATE] tcp      6 src=192.168.0.2 dst=192.168.1.2 sport=37041 dport=80 src=192.168.1.2 dst=192.168.1.100 sport=80 dport=37041 [ASSURED]
> 
> Note that the TCP protocol state is not included. For that reason
> the CT event filtering is not very useful for conntrackd.
> 
> To resolve this issue, instead of conditionally setting the CT events
> bits based on the ctmask, we always set them and perform the filtering
> in the late stage, just before the delivery.
> 
> Thus, the event delivered looks like the following:
> 
>  [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.0.2 dst=192.168.1.2 sport=37041 dport=80 src=192.168.1.2 dst=192.168.1.100 sport=80 dport=37041 [ASSURED]
> 

Looks good to me, applied, thanks. Do you want me to push this
one to -stable as well?
