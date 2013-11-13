From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] json: remove the rule flags in ruleset
 file
Date: Thu, 14 Nov 2013 00:43:30 +0100
Message-ID: <20131113234330.GA28009@localhost>
References: <20131111200921.19419.32343.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46970 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3KMXni (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:43:38 -0500
Content-Disposition: inline
In-Reply-To: <20131111200921.19419.32343.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 11, 2013 at 09:09:21PM +0100, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> This patch fix the unconsistence of this file with the
> commit 2cba09966c77e946f6f32e860a368a0c5a9830a0
>=20
> rule: remove NFT_RULE_ATTR_FLAGS

Prefered format to refer to patches is (2cba09 rule: remove
NFT_RULE_ATTR_FLAGS).

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
