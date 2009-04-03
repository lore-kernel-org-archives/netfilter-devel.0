From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Looking for a example of reading incoming IP
Date: Fri, 3 Apr 2009 18:28:53 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904031826020.28939@fbirervta.pbzchgretzou.qr>
References: <233215.95431.qm@web43411.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Kunsheng Chen <kunsheng.chen@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48399 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936678AbZDCQ25 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:28:57 -0400
In-Reply-To: <233215.95431.qm@web43411.mail.sp1.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-04-03 05:01, Kunsheng Chen wrote:
>
>I am looking for a example of netfilter hook to read the ip address
> of incoming packets in both PreRoute and PostRoute.

Have a look at the Writing Netfilter Modules e-book
(http://jengelh.medozas.de/), section=C2=A02 ("match extension"), which
presents a fictional ipaddr module for demonstrational purposes
that reads and prints said address.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
