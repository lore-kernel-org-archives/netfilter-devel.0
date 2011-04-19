From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Don't load ip6?_tables module when already loaded.
Date: Tue, 19 Apr 2011 09:14:32 +0200
Message-ID: <4DAD3658.9090004@trash.net>
References: <4DAD33B9.3030802@trash.net> <1303197023-9262-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33002 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1DSHOy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:14:54 -0400
In-Reply-To: <1303197023-9262-1-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.04.2011 09:10, Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>=20
> Signed-off-by: Maciej Zenczykowski <maze@google.com>
> ---
>  xshared.h |    2 ++
>  xtables.c |   38 +++++++++++++++++++++++++++++++++-----
>  2 files changed, 35 insertions(+), 5 deletions(-)

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
