From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: arp: fix STRING_OVERFLOW
Date: Thu, 17 Oct 2013 10:37:39 +0200
Message-ID: <20131017083739.GA8309@localhost>
References: <1381569712-7835-1-git-send-email-giuseppelng@gmail.com>
 <525B8BC3.6070804@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55165 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab3JQIho (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:37:44 -0400
Content-Disposition: inline
In-Reply-To: <525B8BC3.6070804@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 14, 2013 at 09:14:27AM +0300, Tomasz Bursztyka wrote:
> Hi Giuseppe Longo a =E9crit :
>=20
>=20
> >This patch replace strcat with strncat and strcpy with strncpy
> >fixing possible string overflow.
>=20
> Can you remind in the commit message that this patch is a backport
> of the patch http://patchwork.ozlabs.org/patch/279672/ ?
> (I mean: name the original author)

I have applied this patch including this information.

As Tomasz said. giving credits is a good practise, please do so in the
future, and address Tomasz requests otherwise I may discard your
patches next time if you don't do so. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
