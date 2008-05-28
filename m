From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] accounting on ct kill
Date: Wed, 28 May 2008 06:07:30 +0200
Message-ID: <483CDA82.8090802@trash.net>
References: <1211447601.6878.38.camel@pumper.lan.luxnet.ch>	 <1211826305.19222.8.camel@pumper.lan.luxnet.ch>	 <483B93C2.1000905@trash.net> <483C1B9D.5060705@gmx.ch>	 <483C1F54.6040505@trash.net> <1211928920.14366.12.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38447 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYE1EHe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 00:07:34 -0400
In-Reply-To: <1211928920.14366.12.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Introduces nf_ct_kill_acct() which increments the accounting counters on
> conntrack kill. The new function was necessary, because there are calls
> to nf_ct_kill() which don't need accounting:
> 
> nf_conntrack_proto_tcp.c line ~847:
> Kills ct and returns NF_REPEAT. We don't want to count twice.
> 
> nf_conntrack_proto_tcp.c line ~880:
> Kills ct and returns NF_DROP. I think we don't want to count dropped
> packets.
> 
> nf_conntrack_netlink.c line ~824:
> As far as I can see ctnetlink_del_conntrack() is used to destroy a
> conntrack on behalf of the user. There is an sk_buff, but I don't think
> this is an actual packet. Incrementing counters here is therefore not
> desired.

Good points. Applied, thanks Fabian.

I've also pulled in Dave's latest net-next-2.6.git tree and will
push it out now.
