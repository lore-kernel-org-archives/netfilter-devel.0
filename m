From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] json: remove space in Json output support
Date: Thu, 17 Oct 2013 10:05:22 +0200
Message-ID: <20131017080522.GA5260@localhost>
References: <20131013195233.6261.62757.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eric@regit.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43673 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab3JQIFa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:05:30 -0400
Content-Disposition: inline
In-Reply-To: <20131013195233.6261.62757.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 13, 2013 at 09:52:34PM +0200, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Remove all the spaces inside JSON output support for reducing size
> of output buffer and create consistence with table, chain, rule
> and set.

Applied, thanks =C1lvaro.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
