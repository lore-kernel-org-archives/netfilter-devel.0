From: Peter Hallberg <hallberg68@hotmail.com>
Subject: Request: Remove duplicate file names in the kernel source
Date: Tue, 2 Sep 2008 23:53:35 +0200
Message-ID: <BLU122-W19B435CA307A7ED8A80E18DA5F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu0-omc1-s13.blu0.hotmail.com ([65.55.116.24]:55606 "EHLO
	blu0-omc1-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbYIBVxg convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:53:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

The netfilter sources in the Linux Kernel contains a number of files th=
at is duplicates expect for the case, like foo.c and FOO.c, this create=
s a problem when untaring the kernel source on a filesystem that doesn'=
t support it like the common Windows file systems, sometimes you have t=
he need to study the kernel source on other systems and it really is un=
ecessary and confusing to have this naming so I would like to ask you t=
o change it, below is a list of the files:

include\linux\netfilter\xt_connmark.h
include\linux\netfilter\xt_dscp.h
include\linux\netfilter\xt_mark.h
include\linux\netfilter\xt_rateest.h
include\linux\netfilter\xt_tcpmss.h
include\linux\netfilter_ipv4\ipt_connmark.h
include\linux\netfilter_ipv4\ipt_dscp.h
include\linux\netfilter_ipv4\ipt_ecn.h
include\linux\netfilter_ipv4\ipt_mark.h
include\linux\netfilter_ipv4\ipt_tcpmss.h
include\linux\netfilter_ipv4\ipt_tos.h
include\linux\netfilter_ipv4\ipt_ttl.h
include\linux\netfilter_ipv6\ip6t_hl.h
include\linux\netfilter_ipv6\ip6t_mark.h
net\ipv4\netfilter\ipt_ecn.c
net\ipv4\netfilter\ipt_ttl.c
net\ipv6\netfilter\ip6t_hl.c
net\netfilter\xt_connmark.c
net\netfilter\xt_dscp.c
net\netfilter\xt_mark.c
net\netfilter\xt_rateest.c
net\netfilter\xt_tcpmss.c

_________________________________________________________________
Hetaste modetipsen & h=E4rligaste sk=F6nhetstesterna!
http://salongk.msn.se/--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
