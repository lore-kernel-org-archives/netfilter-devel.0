From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 1/5] conntrack: support delete by label
Date: Mon, 1 Feb 2016 12:02:22 +0100
Message-ID: <20160201110222.GE8095@salvia>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Clemence Faure <clemence.faure@sophos.com>, fw@strlen.de
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56050 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbcBALC1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 06:02:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8255D1B5CFF
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:02:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6DB8CDA80C
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:02:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 08184DA80C
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:02:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 25, 2016 at 11:15:44AM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> This option was already silently allowed by 991fc4ae,
> but didn't have any effect.
>=20
> This patch adds the check and documents it.

Applied, thanks.

> Cc: Clemence Faure <clemence.faure@sophos.com>
> Signed-off-by: Asbj=F8rn Sloth T=F8nnesen <ast@fiberby.dk>
> ---
>=20
> Notes:
>     I tried to create a test case, as well but I didn't
>     seam to be able to get --label-add to work with
>     create.

Cc'ing Florian. I think it would be good to have a test for this label
support for conntrack.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
