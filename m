From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFD,patch] ICMP echo conntrack timeout
Date: Tue, 02 Jun 2009 14:48:59 +0200
Message-ID: <4A251FBB.8060804@trash.net>
References: <20090601174352.GH31797@fi.muni.cz> <4A251127.8000605@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kasprzak <kas@fi.muni.cz>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38706 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZFBMtB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:49:01 -0400
In-Reply-To: <4A251127.8000605@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
>> 	I think it would be better to keep the default timeout of
>> nf_ct_icmp_timeout even after the echo reply is received. Feel free
>> to correct me why early deleting of ICMP conntrack entries is needed,
>> or consider applying the following patch.
> 
> The only problem that I see is that you patch relaxes the current
> checking that we're doing. I mean, for every packet in one direction we
> only accept one ICMP reply packet. With your patch, we can accept more
> than one packet in the reply direction.

Thats the intention, isn't it? :) I don't see a problem with this,
conntrack is supposed to accept valid responses and I don't think
its unreasonable to consider duplicate echo-replies as valid.


