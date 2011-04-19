From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/5] Add --ipv4/-4 and --ipv6/-6 support to ip6?tables{,-restore}.
Date: Tue, 19 Apr 2011 09:17:19 +0200
Message-ID: <4DAD36FF.7070909@trash.net>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com> <1303176233-14063-2-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33038 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1DSHRj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:17:39 -0400
In-Reply-To: <1303176233-14063-2-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.04.2011 03:23, Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
> =C2=B4
> +		case '4':
> +			/* This is not the IPv4 iptables */
> +			if (line !=3D -1) return 1; /* success: line ignored */

Please use separate lines for statements after conditions
everywhere.

> +			fprintf(stderr, "This is the IPv6 version of ip6tables.\n");
> +			exit_tryhelp(2);
> +
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
