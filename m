From: Thierry Du Tre <thierry@dtsystems.be>
Subject: Re: [PATCH v3] netfilter : add NAT support for shifted portmap ranges
Date: Tue, 16 Jan 2018 22:26:03 +0100
Message-ID: <fbbfc079-dbe6-739d-562f-aaf900731438@dtsystems.be>
References: <7503dae4-e597-c3ca-1671-a24809be4ed0@dtsystems.be>
 <c4e20749-09c1-b78c-845a-13c94d5cd739@dtsystems.be>
 <20180116143218.xlgqmh7pmmaxfcco@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38909 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbeAPV0G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 16:26:06 -0500
Received: by mail-wm0-f68.google.com with SMTP id 141so11424850wme.3
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 13:26:05 -0800 (PST)
In-Reply-To: <20180116143218.xlgqmh7pmmaxfcco@salvia>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 16/01/2018 om 15:32 schreef Pablo Neira Ayuso:
> Hi Thierry,
> 
> On Mon, Jan 15, 2018 at 01:56:09PM +0100, Thierry Du Tre wrote:
>> Hi Pablo,
>>
>> I prepared this third version to get aligned about the way forward for the extension for struct nf_nat_range.
>>
>> Renaming the old definition as you suggested indeed results in a much smaller patch for netfilter kernel part.
>> However, doing it like this also means that userspace code will require changes to cope with the new value for sizeof(struct nf_nat_range).
>>
>> i.e. iptables-1.6.1 :
>>
>> ./extensions/libip6t_SNAT.c:306:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>> ./extensions/libip6t_DNAT.c:290:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>> ./extensions/libip6t_NETMAP.c:89:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>> ./extensions/libip6t_MASQUERADE.c:159:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>> ./extensions/libip6t_REDIRECT.c:158:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>>
>> As far as I understand, all these xt target modules will have to increment their revision which makes them incompatible with current kernel versions.
>> The other option is to replace all occurences of nf_nat_range with nf_nat_range1 in these userspace libraries.
>> That would solve iptables but possible other applications might also be impacted ?
>>
>> Somehow this doesn't seem right to me, so I might have misinterpreted your earlier response.
> 
> I guess you need to add new revisions for the userspace code too,
> right? Am I missing anything?
 
I would sure add a new revision for SNAT and DNAT. In theory I could do that for the others too, although that won't enable any new functionality there.

The problem is about the renaming of the current nf_nat_range to nf_nat_range_old, and using nf_nat_range to name the new extended struct :

+struct nf_nat_range_old {
+       unsigned int                    flags;
+       union nf_inet_addr              min_addr;
+       union nf_inet_addr              max_addr;
+       union nf_conntrack_man_proto    min_proto;
+       union nf_conntrack_man_proto    max_proto;
+};
+
 struct nf_nat_range {
        unsigned int                    flags;
        union nf_inet_addr              min_addr;
        union nf_inet_addr              max_addr;
        union nf_conntrack_man_proto    min_proto;
        union nf_conntrack_man_proto    max_proto;
+       union nf_conntrack_man_proto    base_proto;
 };

In order to keep iptables extensions backwards compatible with current and previous kernel versions -which don't have the new revision-, we need to replace all nf_nat_range occurences in those with nf_nat_range_old.
Otherwise, when compiling with the new extended definition for nf_nat_range, the xt_target structures with current revision will use different sizes for the datablob sent to kernel.
i.e. libip6t_REDIRECT.c :
static struct xtables_target redirect_tg_reg = {
	.name		= "REDIRECT",
	.version	= XTABLES_VERSION,
	.family		= NFPROTO_IPV6,
	.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
...
}
Values for .size and .userspacesize will increase which makes the blob sent to kernel larger than netfilter REDIRECT (xt_target revision=0) currently expects.

I hope this explains my concern correctly. My apologies if not..
