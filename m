From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 2/2] netfilter: IPv6: fix DSCP mangle code
Date: Mon, 6 Jun 2011 21:15:56 -0700
Message-ID: <BANLkTikaTp3NAhy307vkH_pUVSgoFuvgVQ@mail.gmail.com>
References: <1307320871-31770-1-git-send-email-pablo@netfilter.org>
	<1307320871-31770-2-git-send-email-pablo@netfilter.org>
	<BANLkTikAs7fN2JQJTUwQHAYPPGMf8i9uEA@mail.gmail.com>
	<1307411912.6576.8.camel@nexus.oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org, stable@kernel.org,
	netfilter-devel@vger.kernel.org,
	=?UTF-8?Q?Fernando_Luis_V=C3=A1zquez_Cao?= <fernando@oss.ntt.co.jp>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:42269 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1FGEP5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:15:57 -0400
Received: by pxi2 with SMTP id 2so3328995pxi.10
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2011 21:15:56 -0700 (PDT)
In-Reply-To: <1307411912.6576.8.camel@nexus.oss.ntt.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm still opposed on the grounds that there may be people relying on
the current behaviour.
This should not make it into the stable series of kernels.
I can understand fixing it for a future upstream release.
