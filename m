From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] datatype: concat expression only releases dynamically
 allocated datatype
Date: Sat, 8 Jun 2013 15:30:47 +0200
Message-ID: <20130608133047.GB6723@localhost>
References: <1370518645-9812-1-git-send-email-pablo@netfilter.org>
 <1370686421.5642.3.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60193 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab3FHNav (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 09:30:51 -0400
Content-Disposition: inline
In-Reply-To: <1370686421.5642.3.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 08, 2013 at 12:13:41PM +0200, Eric Leblond wrote:
> Hi,
>=20
> Le jeudi 06 juin 2013 =E0 13:37 +0200, Pablo Neira Ayuso a =E9crit :
> > Eric Leblond reports a crash with the following invalid command:
> >=20
> >  nft add rule global filter ip daddr . tcp dport { 192.168.0.1 . 22=
\; 192.168.0.3 . 89 } drop
>=20
> I confirm this patch fixes the issue.

Pushed, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
