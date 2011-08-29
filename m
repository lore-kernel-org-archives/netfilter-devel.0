From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables fixes 2011-08-26
Date: Mon, 29 Aug 2011 22:44:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108292244100.21016@frira.zrqbmnf.qr>
References: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:53912 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1H2UoZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:44:25 -0400
In-Reply-To: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-08-26 15:15, Jan Engelhardt wrote:

>
>The following changes since commit 4a56bcbd49ef20a0203017c15ab1cec9bb1=
40d1a:
>
>  libxt_hashlimit: observe new default gc-expire time when saving (201=
1-08-21 13:04:40 +0200)
>
>are available in the git repository at:
>  git://dev.medozas.de/iptables fixes
>
>Fernando Luis V=C3=A1zquez Cao (1):
>      libxt_TOS: update linux kernel version list for backported fix
>
>Jan Engelhardt (4):
>      libxt_string: simplify hex output routine
>      libxt_string: replace hex codes by char equivalents
>      src: remove unused IPTABLES_MULTI define
>      libxt_string: escape the escaping char too

Automerged after 96-hour timeout.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
