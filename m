From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: xtables: remove table restrictions from some
 modules
Date: Fri, 21 Dec 2012 12:02:34 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212211201110.32410@nerf07.vanv.qr>
References: <1355839621-14206-1-git-send-email-jengelh@inai.de> <CAHo-OowdeVrzc8GfMes0y-LLpq4Kxei=nuGdih7hkyAvk3ahWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, jhs@mojatatu.com,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:55341 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2LULCg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:02:36 -0500
In-Reply-To: <CAHo-OowdeVrzc8GfMes0y-LLpq4Kxei=nuGdih7hkyAvk3ahWw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-12-21 11:19, Maciej =C5=BBenczykowski wrote:

>I'm not sure about the current state.
>But there used to be code that would cause a mangle tables tos change
>to trigger a reroute.
>I'm guessing this wouldn't work if tos was changed from another table.

Indeed, changing TOS from "filter" will not influence the route,
but you can still do so by way of using TOS in "mangle".
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
