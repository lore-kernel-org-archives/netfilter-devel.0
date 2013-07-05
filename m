From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] set: add Json Export Support
Date: Sat, 6 Jul 2013 00:22:57 +0200
Message-ID: <20130705222018.GA9158@localhost>
References: <20130705123837.23285.5489.stgit@Ph0enix>
 <20130705124128.23285.30238.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eric@regit.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49160 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3GEWXF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:23:05 -0400
Content-Disposition: inline
In-Reply-To: <20130705124128.23285.30238.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 05, 2013 at 02:41:28PM +0200, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  examples/nft-set-elem-get.c |   15 ++++++++----
>  examples/nft-set-get.c      |   15 ++++++++----
>  include/libnftables/set.h   |    5 ++++
>  src/set.c                   |   56 +++++++++++++++++++++++++++++++++=
++++++++--
>  src/set_elem.c              |   49 +++++++++++++++++++++++++++++++++=
+++--
>  5 files changed, 126 insertions(+), 14 deletions(-)

Applied, thanks Alvaro.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
