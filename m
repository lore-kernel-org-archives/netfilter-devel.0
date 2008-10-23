From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] fix compile error in libxt_condition
Date: Thu, 23 Oct 2008 15:10:23 +0200
Message-ID: <200810231510.23807.thomas.jarosch@intra2net.com>
References: <200810231232.17331.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0810230815190.14500@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:36832 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbYJWNKe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:10:34 -0400
In-Reply-To: <alpine.LNX.1.10.0810230815190.14500@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday, 23. October 2008 14:18:26 Jan Engelhardt wrote:
> >libxt_condition.c:95: error: static declaration of 'libxt_condition_init'
> > follows non-static declaration ../include/xtables/internal.h:64: error:
> > previous declaration of 'libxt_condition_init' was here
>
> Does this only hit libxt_condition? Who set the XTABLES_INTERNAL macro
> to trigger inclusion of xtables/internal.h?

Good question, I manually downloaded libxt_condition from your gitweb as it's 
the only extension I needed from xtables addons. XTABLES_INTERNAL gets set
by the "extensions/GNUmakefile" in "regular_CFLAGS".
A quick grep reveals it gets always defined in configure.ac.

Thomas

