From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] RFC - introduce xtables-multi
Date: Tue, 5 Apr 2011 11:57:02 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104051151330.8800@obet.zrqbmnf.qr>
References: <1301996959-7342-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37601 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1DEJ5E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:57:04 -0400
In-Reply-To: <1301996959-7342-1-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-04-05 11:49, Maciej =C5=BBenczykowski wrote:

>From: Maciej =C5=BBenczykowski <maze@google.com>
>
>I'm posting this mostly to inspire discussion.
>
>I'd like to merge iptables-multi and ip6tables-multi
>into a single multi-purpose binary xtables-multi.
>
>I can think of a few ways to do this... any preferences?
>
>a) we delete iptables-multi and ip6tables-multi and only build xtables=
-multi
>which depending on whether we're including v4 and/or v6 has different =
capabilities
>unfortunately we lose support for 'iptables-multi save', since with 'x=
tables-multi save'
>it would not be clear whether ipv4 or ipv6 was meant

There is only one time when you want to use `iptables-multi save`, and=20
that is when you are running it from within the object directory you=20
just compiled. In a standard system, i.e. where iptables is in=20
/usr/sbin, the symlinks will be used.

Since iptables/iptables-save/iptables-restore are currently symlinks to=
=20
iptables-multi, and the action is determined by looking at argv[0],
changing iptables-multi into xtables-multi merely means augmenting the=20
name checks. (/usr/sbin/)iptables-multi and ip6tables-multi can then=20
simply be removed.

As for the in-object-dir build, just add recognition for a "save6"=20
string.

>+	{"iptables",          iptables_main},
>+	{"iptables-save",     iptables_save_main},
>+	{"iptables-restore",  iptables_restore_main},
>+	{"iptables-xml",      iptables_xml_main},
>+	{"ip6tables",         ip6tables_main},
>+	{"ip6tables-save",    ip6tables_save_main},
>+	{"ip6tables-restore", ip6tables_restore_main},
>+	{NULL},

Just like this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
