From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 4/5 v2] conntrack: add support for netmask
 filtering
Date: Mon, 1 Feb 2016 12:04:23 +0100
Message-ID: <20160201110423.GH8095@salvia>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
 <1453720548-14413-4-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57177 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbcBALEf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 06:04:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E6ED4303D0D
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:04:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D6C6EDA808
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:04:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E2C48DA808
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:04:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453720548-14413-4-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 25, 2016 at 11:15:47AM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> This patch extends --mask-src and --mask-dst to also work
> with the conntrack table, with commands -L, -D, -E and -U.
>=20
> Signed-off-by: Asbj=F8rn Sloth T=F8nnesen <ast@fiberby.dk>
> ---
>=20
> Notes:
>     This is almost completely backward compatible,
>     since the --mask-* arguments previously gave
>     an error is used with these commands and the
>     conntrack table.
>    =20
>     I have changed the global_family to filter_family,
>     and it is only used to pass the family to the callback,
>     the alternative would be to change the data argument of
>     the callbacks to a struct.

I see changes with regards to previous patchset, not we don't use
cidr. I think this is better since it allows a more compact way.

I prefer the cidr-based approach, any reason to drop it?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
