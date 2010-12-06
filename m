From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Mon, 6 Dec 2010 23:37:30 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012062336380.27578@obet.zrqbmnf.qr>
References: <87sjyercks.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr> <874oaroznk.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012061334090.19952@obet.zrqbmnf.qr> <87tyirnhs1.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012061457220.29349@obet.zrqbmnf.qr>
 <AANLkTikp3b9WcRFr6aMcn9qJ6VULr75SVHOmpyqb955W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ferenc Wagner <wferi@niif.hu>, netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35308 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0LFWhc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:37:32 -0500
In-Reply-To: <AANLkTikp3b9WcRFr6aMcn9qJ6VULr75SVHOmpyqb955W@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-12-06 23:21, Maciej =C5=BBenczykowski wrote:

>Couldn't (shouldn't?) this have been done better with a '-n' command l=
ine
>flag?

The problem _was_ that resolution would take place even in the presence=
=20
of requesting numeric output (as triggered by -n, among others).

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
