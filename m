From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Wed, 9 Mar 2016 00:25:21 +0100
Message-ID: <56DF5F61.2060000@c-s.fr>
References: <56DAC502.2060809@c-s.fr>
 <20160307132011.GA7620@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:31810 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbcCHXZb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 18:25:31 -0500
In-Reply-To: <20160307132011.GA7620@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Le 07/03/2016 14:20, Patrick McHardy a =E9crit :
> On 05.03, christophe leroy wrote:
>> Hello,
>>
>> I'm trying to implement support for CT HELPERs in linux kernel for
>> nftables and need some help/guidance.
>>
>> The rule beeing 'udp dport tftp ct helper set "tftp"', I get
>> nft_ct_set_init() called when I add the rule in the table output fil=
ter
>> table.
>>
>> I believe I have to call nf_ct_helper_ext_add() from nft_ct_set_init=
(),
>> but for that I need the name of the helper that is to be set, ie 'tf=
tp'.
>> How do I get the name of the requested helper in that function ? I
>> suppose once I get it I can do the same as  xt_ct_set_helper() does.
> This depends on how we want to implement this. We could pass a static=
 helper
> name in a new CT attribute, look the helper up in the init path and a=
ssign it
> to the conntrack in the eval function. This means we'd require a sing=
le rule
> for every helper assignment.
How do we add a new CT attribute for that ? Is there any exemple in=20
other parts of the kernel for doing that ?
Is it just to add a NFTA_CT_HELPER then add it in the nft_ct_policy=20
structure as an NLA_STRING type and then retrieve it with nla_strl_cpy(=
) ?
But how does it gets populated with the helper string passed in by nft =
?

Christophe


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
