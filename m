From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: Re: [PATCH] netfilter: install nf_nat.h and nf_conntrack_tuple.h
 to INSTALL_HDR_PATH
Date: Thu, 29 Sep 2011 17:03:55 -0400
Message-ID: <4E84DD3B.5030901@opensource.dyc.edu>
References: <1315527377-28528-1-git-send-email-basile@opensource.dyc.edu> <20110912083839.GA2017@1984> <20110912091913.GA2194@1984> <4E78B253.7060502@opensource.dyc.edu> <20110928213754.GD2761@1984>
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
Received: from virtual.dyc.edu ([67.222.116.22]:45061 "EHLO virtual.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817Ab1I2VD6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Sep 2011 17:03:58 -0400
In-Reply-To: <20110928213754.GD2761@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/28/2011 05:37 PM, Pablo Neira Ayuso wrote:
> On Tue, Sep 20, 2011 at 11:33:39AM -0400, Anthony G. Basile wrote:
>> Sorry for the delay in responding, real life.
>>
>> What I did in that last patch was just grab nf_nat.h and
>> nf_contrack_tupple.h from iptables source tree at include/net/netfilter
>> plus minor changes.  I didn't look for the minimum of what iptables and
>> miniupnpd need.
>>
>> Here's a possibility that works, move nf_conntrack_man_proto to nf_nat.h
>> and only export that header with:
> 
> I guess, you mean the new include/linux/netfilter/nf_nat.h file, right?

Yes, that's what I meant.

> 
>>     #define IP_NAT_RANGE_MAP_IPS 1
>>     ...
>>
>>     union nf_conntrack_man_proto {
>>         __be16 all;
>>         struct { __be16 port } tcp;
>>         ...
>>     }
> 
> If you want to keep the "port" field, I'd prefer something like:
> 
> union nf_conntrack_man_proto {
>         __be16 port;
>         __be16 icmp_id;
>         __be16 gre_key;
> };
> 
> And propagate the changes to the corresponding .c files.
> 

Got it.

>>     struct nf_nat_range {
>>         ...
>>         union nf_conntrack_man_proto min, max;
>>     };
>>
>>     struct nf_nat_multi_range_compat { ... }
>>
>>     #define nf_nat_multi_range nf_nat_multi_range_compat
>>
>> This is the minimum that iptables and miniupnpd need to compile.
>>
>> Does this look like a workable solution?
> 
> Close to it, but please change union nf_conntrack_man_proto to what I
> suggested.

Yep.  I like it too.  I'll make the changes, make sure kernel land is
okay, test iptables and miniupnpd against it and then resubmit.

-- 
Anthony G. Basile, Ph. D.
Chair of Information Technology
D'Youville College
Buffalo, NY 14201
(716) 829-8197
