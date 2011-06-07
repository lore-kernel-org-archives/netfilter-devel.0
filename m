From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 2/2] netfilter: IPv6: fix DSCP mangle code
Date: Mon, 6 Jun 2011 23:03:54 -0700
Message-ID: <BANLkTin2bTj9nW9kFvYWh8v0+LDbBLuYUT1Nn6Dq4LmK3_BTqw@mail.gmail.com>
References: <1307320871-31770-1-git-send-email-pablo@netfilter.org>
	<1307320871-31770-2-git-send-email-pablo@netfilter.org>
	<BANLkTikAs7fN2JQJTUwQHAYPPGMf8i9uEA@mail.gmail.com>
	<1307411912.6576.8.camel@nexus.oss.ntt.co.jp>
	<BANLkTikaTp3NAhy307vkH_pUVSgoFuvgVQ@mail.gmail.com>
	<1307422292.6576.54.camel@nexus.oss.ntt.co.jp>
	<1307422500.6576.57.camel@nexus.oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org, stable@kernel.org,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Fernando_Luis_V=C3=A1zquez_Cao?= <fernando@oss.ntt.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:39580 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1FGGDz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:03:55 -0400
Received: by pxi2 with SMTP id 2so3385978pxi.10
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2011 23:03:55 -0700 (PDT)
In-Reply-To: <1307422500.6576.57.camel@nexus.oss.ntt.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> As an aside, we could even add a note to the relevant man page saying
> that the IPv6 DSCP mangle code used to be broken but not anymore (it has
> been done before).

That sounds reasonable - especially if we make it clear which versions
of the kernel are affected.
Unfortunately, people upgrade kernel and utilities seperately...
[theoretically iptables could detect kernel version and automatically
invert the mask for too old kernels...]
