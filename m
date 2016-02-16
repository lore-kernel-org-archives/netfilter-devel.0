From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 3/4 v2] conntrack: add support for CIDR notation
Date: Tue, 16 Feb 2016 19:19:20 +0100
Message-ID: <20160216181920.GE20397@salvia>
References: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
 <1454333407-6335-3-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38235 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbcBPST1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 13:19:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D1E631E11DA
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:19:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BB5DD1B60D8
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:19:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AF2F41B60D8
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:19:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1454333407-6335-3-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 01, 2016 at 01:30:06PM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> Add support for using CIDR notation in --{orig,tuple}-{src,dst} argum=
ents,
> instead of free-form formatting netmask in --mask-{src,dst}.
>=20
> Example:
>   conntrack -L -s 2001:db8::/56
>=20
> Instead of:
>   conntrack -L -s 2001:db8:: --mask-src ffff:ffff:ffff:ff00::

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
