From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] xtables-multi: fix absence of xml translator in IPv6-only builds
Date: Tue, 7 Jun 2011 11:04:39 -0700
Message-ID: <BANLkTikyH6yUTv3kjykYVSPONoz_qOkJHA@mail.gmail.com>
References: <1307410029-6104-1-git-send-email-zenczykowski@gmail.com>
	<alpine.LNX.2.01.1106071110580.25037@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:52711 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab1FGSEk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:04:40 -0400
Received: by pxi2 with SMTP id 2so3869173pxi.10
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jun 2011 11:04:39 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1106071110580.25037@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2011/6/7 Jan Engelhardt <jengelh@medozas.de>:
> Simply put this in xshared.h.

Theoretically this is only needed for compilation of xtables-multi,
and thus doesn't quite strictly belong in xshared.h.

I was also thinking of renaming the files iptables-xml.* to
xtables-xml.* to make it better reflect that it isn't ip4tables
specific
(a binary symlink would continue to exist).
