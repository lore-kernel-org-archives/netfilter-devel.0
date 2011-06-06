From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] netfilter: IPv6: fix DSCP mangle code
Date: Mon, 6 Jun 2011 16:41:37 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106061618370.17430@frira.zrqbmnf.qr>
References: <1307320871-31770-1-git-send-email-pablo@netfilter.org> <1307320871-31770-2-git-send-email-pablo@netfilter.org> <BANLkTikAs7fN2JQJTUwQHAYPPGMf8i9uEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, stable@kernel.org,
	netfilter-devel@vger.kernel.org,
	Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41916 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1FFOlk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:41:40 -0400
In-Reply-To: <BANLkTikAs7fN2JQJTUwQHAYPPGMf8i9uEA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-06-06 15:44, Maciej =C5=BBenczykowski wrote:

>> The mask indicates the bits one wants to zero out, so it needs to be
>> inverted before applying to the original TOS field.
>
>Uhm, does it?
>This is backwards incompatible...
>
>To me, you always 'and' with a mask, not with the negation of the mask=
=2E
>ie. a mask is the bits you want to keep.

That certainly is not set into stone.

If you model a sculpture into an ice/concrete/wood/etc. block, you=20
usually specify what to take away rather than what to leave, to take a=20
non-abstract example. But see below.


>(mind you I haven't looked at the documentation of the feature,

[You should do that.]

xt_MARK does the same as xt_TOS, and both should be using &~ - because=20
--set-mark 0x12/0x0f has always meant "kill 0x3f, then set 0x12".

I wager to say that the most common applications are:

 --set-mark somevalue/samevalue
 --set-mark somevalue/0xff

so having to calculate the negation of samevalue is usually wasted brai=
n=20
time.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
