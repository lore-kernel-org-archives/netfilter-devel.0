From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 5/5] add xtables-multi{32,64} recognition
Date: Tue, 19 Apr 2011 00:29:58 -0700
Message-ID: <BANLkTinbg_38zymRyTvpXZ1zcms76G1L1w@mail.gmail.com>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
	<1303176233-14063-5-git-send-email-zenczykowski@gmail.com>
	<4DAD3749.1000208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40852 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1DSHaA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:30:00 -0400
Received: by wwa36 with SMTP id 36so6614804wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2011 00:29:58 -0700 (PDT)
In-Reply-To: <4DAD3749.1000208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> What is the purpose of this?

Unfortunately not every 64-bit kernel version has had fully functional
32 bit backwards compatibility with userspace.  As such, it is
sometimes necessary to ship a 32-bit userspace iptables for 32-bit
kernels and a 64-bit binary for 64-bit kernels - sometimes in the same
OS image.

The way I've done this is ship both binaries, one named *32 and one
*64 and then have a launcher at * launch the appropriate one for the
running kernel.

To be fair, these kernels are pretty old at this point, OTOH, the
patch is rather trivial and harmless.

- Maciej
