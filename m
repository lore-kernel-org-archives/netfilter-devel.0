From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC] Inter-match communication cache
Date: Wed, 19 Sep 2012 18:11:51 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209191805590.28614@nerf07.vanv.qr>
References: <alpine.DEB.2.00.1209182232460.5113@blackhole.kfki.hu> <Pine.LNX.4.64.1209191720490.12601@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:51394 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab2ISQLw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:11:52 -0400
In-Reply-To: <Pine.LNX.4.64.1209191720490.12601@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2012-09-19 17:38, Jesper Dangaard Brouer wrote:
>> +++ b/include/linux/netfilter/x_tables.h
>> @@ -216,6 +216,9 @@ struct xt_action_param {
>> 		const void *matchinfo, *targinfo;
>> 	};
>> 	const struct net_device *in, *out;
>> +#ifdef CONFIG_NETFILTER_XTABLES_CACHE
>> +	u_int32_t cache;
>> +#endif
>
> Perhaps we should add it, that the end of the struct, to avoid too big ABI
> breakage.

It makes no difference where it is added. The ABI changes either way.
