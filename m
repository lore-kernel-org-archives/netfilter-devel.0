From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: Re: [PATCH] netfilter: install nf_nat.h and nf_conntrack_tuple.h
 to INSTALL_HDR_PATH
Date: Tue, 20 Sep 2011 11:33:39 -0400
Message-ID: <4E78B253.7060502@opensource.dyc.edu>
References: <1315527377-28528-1-git-send-email-basile@opensource.dyc.edu> <20110912083839.GA2017@1984> <20110912091913.GA2194@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from virtual.dyc.edu ([67.222.116.22]:39707 "EHLO virtual.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1ITPdq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:33:46 -0400
In-Reply-To: <20110912091913.GA2194@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/12/2011 05:19 AM, Pablo Neira Ayuso wrote:
> On Mon, Sep 12, 2011 at 10:38:39AM +0200, Pablo Neira Ayuso wrote:
>>> +/* Single range specification. */
>>> +struct nf_nat_range {
>>> +	/* Set to OR of flags above. */
>>> +	unsigned int flags;
>>> +
>>> +	/* Inclusive: network order. */
>>> +	__be32 min_ip, max_ip;
>>> +
>>> +	/* Inclusive: network order */
>>> +	union nf_conntrack_man_proto min, max;
>>
>> Better replace union nf_conntrack_man_proto by __be16, we don't break
>> binary compatibility and we don't need to export the whole tuple
>> definitions.
> 
> Hm, I just noticed that this will not work that easy.
> 
> git grep shows several NAT protocol helpers that rely on
> nf_conntrack_man_proto under net/ipv4/netfilter/, we need to change
> those as well to use the new definition of nf_nat_range.
> 
> I think I prefer the change that I'm proposing that exporting the
> whole nf_conntrack_tuple.h header file.

Sorry for the delay in responding, real life.

What I did in that last patch was just grab nf_nat.h and
nf_contrack_tupple.h from iptables source tree at include/net/netfilter
plus minor changes.  I didn't look for the minimum of what iptables and
miniupnpd need.

Here's a possibility that works, move nf_conntrack_man_proto to nf_nat.h
and only export that header with:

    #define IP_NAT_RANGE_MAP_IPS 1
    ...

    union nf_conntrack_man_proto {
        __be16 all;
        struct { __be16 port } tcp;
        ...
    }

    struct nf_nat_range {
        ...
        union nf_conntrack_man_proto min, max;
    };

    struct nf_nat_multi_range_compat { ... }

    #define nf_nat_multi_range nf_nat_multi_range_compat

This is the minimum that iptables and miniupnpd need to compile.

Does this look like a workable solution?


-- 
Anthony G. Basile, Ph. D.
Chair of Information Technology
D'Youville College
Buffalo, NY 14201
(716) 829-8197
