From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] [PATCH] dynamic calculation of event message size
 for	ctnetlink
Date: Tue, 18 Nov 2008 12:03:00 +0100
Message-ID: <4922A0E4.5010806@trash.net>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117084141.11368.26975.stgit@Decadence> <49218EA3.8090801@trash.net> <49223799.70505@netfilter.org> <4922973A.7000001@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33874 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYKRLDG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:03:06 -0500
In-Reply-To: <4922973A.7000001@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> These calculations look somewhat expensive to perform for every message.
>>> Do you have any numbers for this new patch that shows the difference
>>> in CPU usage compared to the resizing done by af_netlink.c?
>> Fabian Hugelshofer reported some reduction (~5%) on an embedded
>> environment but he was using top to measure the difference. I'll collect
>> some more trustable data and get back to you.
> 
> Some oprofile results:
> 
> wo/patch
> 2189      0.0305  nf_conntrack_netlink.ko  nf_conntrack_netlink
> ctnetlink_conntrack_event
> 
> w/patch
> 2302      0.0440  nf_conntrack_netlink.ko  nf_conntrack_netlink
> ctnetlink_conntrack_event
> 
> While __alloc_skb and netlink_broadcast report similar values for w/ and
> wo/ the patch.

So its actually getting worse? :) Any other differences, like less
cycles for memcpy in netlink_trim()?
