From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] fix compile error in libxt_condition
Date: Thu, 23 Oct 2008 08:18:26 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810230815190.14500@fbirervta.pbzchgretzou.qr>
References: <200810231232.17331.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52043 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYJWMS3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:18:29 -0400
In-Reply-To: <200810231232.17331.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2008-10-23 06:32, Thomas Jarosch wrote:

>Hello Jan,
>
>attached is a small patch to fix the compilation
>of libxt_condition in xtables_addons using gcc 4.3.2.
>
>Fix compile error in libxt_condition
>
>libxt_condition.c:95: error: static declaration of 'libxt_condition_init' follows non-static declaration
>../include/xtables/internal.h:64: error: previous declaration of 'libxt_condition_init' was here  

Does this only hit libxt_condition? Who set the XTABLES_INTERNAL macro 
to trigger inclusion of xtables/internal.h?
