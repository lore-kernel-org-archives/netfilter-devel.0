From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT connection
Date: Mon, 12 Apr 2010 18:11:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004121811300.8310@obet.zrqbmnf.qr>
References: <F9F341B6-9283-4339-A8C4-B08754B98E01@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Giuseppe_Macr=C3=AC?= <macri.giuseppe.disk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44255 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0DLQLo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:11:44 -0400
In-Reply-To: <F9F341B6-9283-4339-A8C4-B08754B98E01@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-04-12 17:55, Giuseppe Macr=C3=AC wrote:

>Hi,
>I woud like to communicate some information between ip_nat module and =
the user space, not regardin the packet queue but the established conne=
ctions in the nat. Is it possible to use copy_to_user function? In that=
 case do you know which is the syscall related to ip_nat module in orde=
r to retrieve information from user space?
>Or is a different way to retrieve information about nat connection?

man 8 conntrack
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
