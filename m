From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] datatype: fix name of icmp* code
Date: Wed, 3 Dec 2014 12:54:17 +0100
Message-ID: <20141203115417.GA13593@salvia>
References: <1417561371-22624-1-git-send-email-eric@regit.org>
 <547EF31B.9020709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56807 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbaLCLwH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:52:07 -0500
Content-Disposition: inline
In-Reply-To: <547EF31B.9020709@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 03, 2014 at 12:25:15PM +0100, =C1lvaro Neira Ayuso wrote:
> Hi Eric
>=20
> El 03/12/14 a las 00:02, Eric Leblond escribi=F3:
> >The name of datatypes can be used in set definition so they should
> >follow the same logic (and maybe not contain space to avoid problem
> >with parsing).
> >
> >This patch adds an underscore to the name of the icmp* code
> >datatype.
> >
> >Signed-off-by: Eric Leblond <eric@regit.org>
>=20
> Looks good to me. Thanks, I have used a uncorrect name format :)

Applied, thanks for reviewing.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
