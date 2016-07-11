From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 libnfntl] Fix nftnl_*_get to set data_len
Date: Mon, 11 Jul 2016 12:25:00 +0200
Message-ID: <20160711102500.GA11905@salvia>
References: <20160705123125.GA27152@salvia>
 <1467738917-17597-1-git-send-email-carlosfg@riseup.net>
 <1467738917-17597-2-git-send-email-carlosfg@riseup.net>
 <20160711102427.GA10548@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49315 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbcGKKZG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 06:25:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CB2A817DB61
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:25:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B16F0FAB44
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:25:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 27AF59EBD8
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:25:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160711102427.GA10548@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 11, 2016 at 12:24:27PM +0200, Pablo Neira Ayuso wrote:
> Carlos,
>=20
> Habla con Laura para ver c=F3mo lleva este cambio en la reuni=F3n:
>=20
> http://patchwork.ozlabs.org/patch/639253/
>=20
> Si ella no anda con tiempo, creo que t=FA tienes los conocimientos pa=
ra
> hacer este cambio que describo ah=ED.
>=20
> No lo olvides. Gracias.

Sorry, I accidentally sent this email to the mailing list in Spanish.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
