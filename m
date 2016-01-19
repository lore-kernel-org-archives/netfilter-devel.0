From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft: segfault after adding to { type ipv4_addr; flags interval;
 } set
Date: Tue, 19 Jan 2016 19:46:48 +0100
Message-ID: <20160119184648.GA24758@salvia>
References: <1452713709.8513.0@x201s.roaming.asbjorn.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37693 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbcASSqx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2016 13:46:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 94CAB261780
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 19:46:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7CC39DA807
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 19:46:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8B15ADA804
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 19:46:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452713709.8513.0@x201s.roaming.asbjorn.biz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2016 at 07:35:09PM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> Hi,
>=20
> I have been trying to migrate an ipset net:hash set to a nftables set=
=2E
> I don't need the nomatch feature of ipset net:hash, a set with networ=
k
> prefixes should do just fine. I do need it as a named set through.
>=20
> A plain type ipv4_addr set can only hold individual addresses, so
> that doesn't work with network prefixes.
>=20
> I found the flags interval in the bison code, and so I tried
> to test if that would work.
>=20
> # nft add table testtbl
> # nft add set testtbl testset { type ipv4_addr\; flags interval\; }
> # nft add element testtbl testset { 192.168.3.0/24 }
> > BUG: invalid data expression type prefix
> > nft: netlink.c:323: netlink_gen_data: Assertion `0' failed.
> > Aborted
> # nft add element testtbl testset { 192.168.3.0-192.168.3.255 }
> > BUG: invalid data expression type range
> > nft: netlink.c:323: netlink_gen_data: Assertion `0' failed.
> > Aborted
> # nft add element testtbl testset { 192.168.3.0, 192.168.3.255 }
> # nft list tables
> > Segmentation fault
> # nft flush ruleset
> > Segmentation fault
>=20
> How was the interval flag intended to work?

Just posted several patches on the mailing list, it would be good if
you can intensively test them. They apply on top of the current git
tree.

BTW, deletion is not implemented in nft, but I think it should be easy
to follow up with a patch to make it.

> It would be great if the ipset article on the wiki, could have some i=
nfo
> on how to migrate separate ipset types to nftables set types.

Would you like to start such article? I can create an account in the
wiki page too, it would be a nice contribution.

Let me know,
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
