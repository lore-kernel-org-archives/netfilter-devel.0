From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2 3/3] example: removed printf rule function
Date: Sat, 8 Mar 2014 17:45:35 +0100
Message-ID: <20140308164535.GC8040@localhost>
References: <20140308152106.18827.23707.stgit@Ph0enix>
 <20140308152239.18827.18277.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52722 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaCHQpk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 11:45:40 -0500
Content-Disposition: inline
In-Reply-To: <20140308152239.18827.18277.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 08, 2014 at 04:22:48PM +0100, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Removed this code because with that we have a strange
> output. Example:
>=20
> we have a rule with handle 4 and we execute
> nft-rule-del ip filter input 4
>=20
> Output: unknown filter input 4 0

Also applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
