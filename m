From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xtables-multi: fix absence of xml translator in IPv6-only
 builds
Date: Tue, 7 Jun 2011 21:56:21 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106072156090.19995@frira.zrqbmnf.qr>
References: <1307410029-6104-1-git-send-email-zenczykowski@gmail.com> <alpine.LNX.2.01.1106071110580.25037@frira.zrqbmnf.qr> <BANLkTikyH6yUTv3kjykYVSPONoz_qOkJHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:35205 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab1FGT4X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:56:23 -0400
In-Reply-To: <BANLkTikyH6yUTv3kjykYVSPONoz_qOkJHA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-06-07 20:04, Maciej =C5=BBenczykowski wrote:

>2011/6/7 Jan Engelhardt <jengelh@medozas.de>:
>> Simply put this in xshared.h.
>
>Theoretically this is only needed for compilation of xtables-multi,
>and thus doesn't quite strictly belong in xshared.h.
>
>I was also thinking of renaming the files iptables-xml.* to
>xtables-xml.* to make it better reflect that it isn't ip4tables
>specific
>(a binary symlink would continue to exist).

Let me take care of that, I plan to move this into a separate dir=20
already.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
