From: Patrick McHardy <kaber@trash.net>
Subject: Re: Add seperated timeout for the connections that only receive
 packets in one direction
Date: Fri, 27 Nov 2009 11:02:18 +0100
Message-ID: <4B0FA3AA.4070702@trash.net>
References: <4B0F9737.8050606@gmail.com>	 <alpine.DEB.2.00.0911271020160.18988@blackhole.kfki.hu>	 <412e6f7f0911270132o3329843gab40f0c9a50620ae@mail.gmail.com>	 <alpine.DEB.2.00.0911271036100.18988@blackhole.kfki.hu> <412e6f7f0911270159i2e55355end54b64372570b90d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42307 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbZK0KCO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2009 05:02:14 -0500
In-Reply-To: <412e6f7f0911270159i2e55355end54b64372570b90d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Fri, Nov 27, 2009 at 5:42 PM, Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
>> On Fri, 27 Nov 2009, Changli Gao wrote:
>>
>>> Yes, as nf_conntrack_tcp_timeout_loose_unreply implied, it is for
>>> picked up connections.
>> Connection pickup can be disabled by proper rules or by setting
>> nf_ct_tcp_loose to zero. So in which environment this third method is
>> required? I'm curious what triggered you to write your patch.
>>
> 
> In some condition, you can't disable it. It's why we export
> nf_ct_tcp_loose. As a bridge, if its booting breaks connections, users
> won't happy, so we must allow loose mode.

That won't help much. If you're able to spoof packets, you might
as well spoof packets for both direction so SEEN_REPLY is set.
