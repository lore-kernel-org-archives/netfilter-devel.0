From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/8] iptables: use C99 lists for struct options
Date: Mon, 14 Apr 2008 08:42:15 +0200
Message-ID: <4802FCC7.80805@trash.net>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <7e115b3078d0fdeab365664b0098b6690735ac53.1208075035.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?ISO-8859-15?Q?G=E1sp=E1r_Lajos?= <swifty@freemail.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63216 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYDNGmT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:42:19 -0400
In-Reply-To: <7e115b3078d0fdeab365664b0098b6690735ac53.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> From: G=E1sp=E1r Lajos <swifty@freemail.hu>
>=20
> ---
>  ip6tables-restore.c |   18 ++++++------
>  ip6tables-save.c    |   12 ++++----
>  ip6tables.c         |   60 ++++++++++++++++++++--------------------
>  iptables-restore.c  |   20 +++++++-------
>  iptables-save.c     |   12 ++++----
>  iptables.c          |   64 +++++++++++++++++++++--------------------=
-
>  6 files changed, 93 insertions(+), 93 deletions(-)

Applied.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
