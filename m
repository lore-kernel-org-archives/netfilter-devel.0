From: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Subject: kernel BUG at net/netfilter/ipset/ip_set_core.c:314
Date: Tue, 30 Aug 2011 10:58:11 +0200
Message-ID: <4E5CA623.9000402@univ-nantes.fr>
Reply-To: jean-philippe.menil@univ-nantes.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-tls2.univ-nantes.fr ([193.52.101.146]:42581 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1H3JDY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:03:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

With the set bitmap ipmac, if i had one, two hundred ip,mac in a set;=20
and do an ipset list,
i get an:
ipset v6.8: Kernel error received: No buffer space available
followed by a kernel panic (trace attached).

Maybe, in ip_set_core.c, can we modify the line 435 to this one:
if (ip_set_list[index] !=3D NULL && ip_set_list[index]->ref !=3D0)

This way, we avoid the kernel panic?

Regards.

--=20
Jean-Philippe Menil - P=F4le r=E9seau Service IRTS
DSI Universit=E9 de Nantes
jean-philippe.menil@univ-nantes.fr
Tel : 02.53.48.49.27 - Fax : 02.53.48.49.09

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
