From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: socket match - add wildcard option [1/4]
Date: Sun, 25 Jul 2010 17:08:11 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007251707350.3572@obet.zrqbmnf.qr>
References: <AANLkTimmYB92z3J5cysm7-RcQ4oS+-=ZmTCc_9VYQoRf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Nepenthes Development Team <nepenthesdev@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40266 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab0GYPIM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 11:08:12 -0400
In-Reply-To: <AANLkTimmYB92z3J5cysm7-RcQ4oS+-=ZmTCc_9VYQoRf@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-07-25 16:49, Nepenthes Development Team wrote:

>iptables-socket-match-empty-options.diff
> =C2=A0- revert removing the empty options from extensions/xt_socket.c
>

This could simply be merged with the patch that adds the actual
options.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
