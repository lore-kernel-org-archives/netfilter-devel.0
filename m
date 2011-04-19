From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 5/5] add xtables-multi{32,64} recognition
Date: Tue, 19 Apr 2011 09:55:58 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104190950260.25800@obet.zrqbmnf.qr>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com> <1303176233-14063-5-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54315 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1DSH4A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:56:00 -0400
In-Reply-To: <1303176233-14063-5-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-04-19 03:23, Maciej =C5=BBenczykowski wrote:
>diff --git a/xtables-multi.c b/xtables-multi.c
>index f8d56ce..7f98286 100644
>--- a/xtables-multi.c
>+++ b/xtables-multi.c
>@@ -14,20 +14,34 @@
> static const struct subcommand multi_subcommands[] =3D {
> #ifdef ENABLE_IPV4
> 	{"iptables",            iptables_main},
>+	{"iptables32",          iptables_main},
>+	{"iptables64",          iptables_main},

I do not see a reason to having these names added. If you do have
more than one iptables program with different configuration installed
in your custom environment, use some custom shell scripts to readout $0=
=20
and pass control to whatever instance.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
