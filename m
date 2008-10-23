From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] fix compile error in libxt_condition
Date: Thu, 23 Oct 2008 15:39:03 +0200
Message-ID: <200810231539.03977.thomas.jarosch@intra2net.com>
References: <200810231232.17331.thomas.jarosch@intra2net.com> <200810231510.23807.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0810230911550.14500@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:51458 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbYJWNjO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:39:14 -0400
In-Reply-To: <alpine.LNX.1.10.0810230911550.14500@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> >A quick grep reveals it gets always defined in configure.ac.
>
> No way.
>
> 09:11 nuqneh:~/Coding/xtables-addons > grep -r XTABLES_INTERNAL .
> 09:11 nuqneh:~/Coding/xtables-addons >
>
> Wait... you downloaded libxt_condition.c from *xtables-addons*
> and put it into the *iptables/* tree? Well, that is not going
> to fly on its own. You need the patch of course, but then this
> is not an xtables-addons problem.

Thanks for checking! As long as it works on my box, I'm happy :-)

Thomas

