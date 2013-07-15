From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] set: json: fix incomplete output
Date: Tue, 16 Jul 2013 00:11:30 +0200
Message-ID: <20130715221130.GA4492@localhost>
References: <20130715193052.20241.52862.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eric@regit.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44631 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab3GOWLf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:11:35 -0400
Content-Disposition: inline
In-Reply-To: <20130715193052.20241.52862.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 15, 2013 at 09:30:52PM +0200, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> In (bf39c53 set: add json output), the json support for sets was
> incomplete:
>=20
> * version, family, key_type, key_len, data_type, data_len were not in=
cluded.
> * Now I use nft_data_reg_snprintf for printing the key and data

Applied, thanks Alvaro.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
