From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 2/2] netfilter: IPv6: fix DSCP mangle code
Date: Mon, 6 Jun 2011 06:44:16 -0700
Message-ID: <BANLkTikAs7fN2JQJTUwQHAYPPGMf8i9uEA@mail.gmail.com>
References: <1307320871-31770-1-git-send-email-pablo@netfilter.org>
	<1307320871-31770-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: stable@kernel.org, netfilter-devel@vger.kernel.org,
	Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:46597 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFNoR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:44:17 -0400
Received: by pxi2 with SMTP id 2so2817475pxi.10
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2011 06:44:16 -0700 (PDT)
In-Reply-To: <1307320871-31770-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> The mask indicates the bits one wants to zero out, so it needs to be
> inverted before applying to the original TOS field.

Uhm, does it?
This is backwards incompatible...

To me, you always 'and' with a mask, not with the negation of the mask.
ie. a mask is the bits you want to keep.

(mind you I haven't looked at the documentation of the feature, but
I'm still pretty sure the right fix here is to change the docs, not
the functionality)

> The following Linux kernels are affected: <= 2.6.38.8

- Maciej
