From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 2/2] netfilter: log invalid new icmpv6 packet with  nf_log_packet().
Date: Thu, 29 Jan 2009 21:57:21 +0100
Message-ID: <49821831.6000609@inl.fr>
References: <1233261382-17030-1-git-send-email-eric@inl.fr> <1233261382-17030-3-git-send-email-eric@inl.fr> <20090129204754.GA22097@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:52198 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZA2U5a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:57:30 -0500
In-Reply-To: <20090129204754.GA22097@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Alexey Dobriyan a =E9crit :
> On Thu, Jan 29, 2009 at 09:36:22PM +0100, Eric Leblond wrote:
>> --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
>> +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
>> @@ -126,6 +126,10 @@ static bool icmpv6_new(struct nf_conn *ct, cons=
t struct sk_buff *skb,
>>  		pr_debug("icmpv6: can't create new conn with type %u\n",
>>  			 type + 128);
>>  		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
>> +		if (LOG_INVALID(&init_net, IPPROTO_ICMPV6))
>=20
> netns is nf_ct_net(ct) at this point, not &init_net.

Thanks a lot, updated patch to follow.

BR,
--
Eric Leblond <eric@inl.fr>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
