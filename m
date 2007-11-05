From: =?UTF-8?Q?K=C5=82oczko?= Tomasz <kloczek@zie.pg.gda.pl>
Subject: Re: [NETFILTER00/07]: Netfilter update+fixes
Date: Mon, 05 Nov 2007 19:20:54 +0100
Message-ID: <1194286854.2641.4.camel@dhcppc0>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.zie.pg.gda.pl ([153.19.33.3]:1781 "EHLO smtp.zie.pg.gda.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbXKETkm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:40:42 -0500
Received: from localhost (smtp-scanner.admins.zie [192.168.111.20])
	by smtp.zie.pg.gda.pl (Postfix) with ESMTP id B65ED19C076
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Nov 2007 20:21:26 +0100 (CET)
Received: from smtp.zie.pg.gda.pl ([192.168.111.230])
	by localhost (smtp-scanner.admins.zie [192.168.111.20]) (amavisd-new, port 10024)
	with ESMTP id VfN6i-kMNw82 for <netfilter-devel@vger.kernel.org>;
	Mon,  5 Nov 2007 20:21:24 +0100 (CET)
Received: from [10.0.0.4] (87-205-228-8.adsl.inetia.pl [87.205.228.8])
	by smtp.zie.pg.gda.pl (Postfix) with ESMTP id D036F19C063
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Nov 2007 20:21:22 +0100 (CET)
In-Reply-To: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Dnia 02-11-2007, pi=C4=85 o godzinie 12:23 +0100, Patrick McHardy pisze=
:
[..]
>  net/netfilter/xt_connlimit.c        |    5 ++-
>  net/netfilter/xt_time.c             |    3 +-
>  net/netfilter/xt_u32.c              |    5 ++-

Still there is no officialy released stable iptables source tar ball
with connlimit, time and u32 support. It will be good release updated
iptables (1.3.9 ?)

kloczek

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
