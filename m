From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Invalid size of target
Date: Mon, 14 Jul 2008 22:07:00 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807142204050.13215@fbirervta.pbzchgretzou.qr>
References: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com> <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kevin Sookocheff <kevin.sookocheff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47632 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbYGNUHC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:07:02 -0400
In-Reply-To: <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-07-14 21:26, Kevin Sookocheff wrote:

>Hi everyone,
>
>I am having a problem developing an IPTables module.
>
>I get the following error (CSUM is the name of my module):
>
>ip_tables: CSUM target: invalid size 0 != 12
>
>The first question is why this error appears,

Because your xt_CSUM.c file and libxt_CSUM.c do not agree on
the private structure (size).

>and why does it only appear for SMP kernels?

Perhaps you only have a specific change in an SMP kernel?
Or maybe because your private structure contains bad members.
Nobody knows until code is seen.

Read more about the process in
http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
