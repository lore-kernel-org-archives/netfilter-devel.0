From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ulog2-mysql-schema
Date: Mon, 21 Nov 2011 22:49:07 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111212247580.11993@frira.zrqbmnf.qr>
References: <4EC9C0DA.8050705@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, eric@regit.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44352 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757225Ab1KUVtJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:49:09 -0500
In-Reply-To: <4EC9C0DA.8050705@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc-forwarding to nf-dev, and Eric and Pablo, who do ulogd2.

On Monday 2011-11-21 04:09, marty wrote:

> I use ulog2 to log syslog and packet data to mysql.
> I parse the data for web display using cron scripts; mostly php.
> All work very reliably and I really love ulog2 despite it's beta...
> (but the latest beta was very broken for me. I use orig beta4.)
>
> The example MySQL schemas with ulog2 are very complex and problematic, plus
> have errors and no guidance. Not being updated either...
>
> I wrote my own sql to handle logging tcp/udp packets.
> My schema is quite simple and works fine for me on Linux-3, so I took the time
> to add some complete tutorial stuff to that sql file.
> Should make it easier to get ulog/mysql working.
> I have attached my sql (zipped) to this message, as a donation.
> Please take a look.
> If you think this is useful in the ulog docs dir feel free to push
> it with any filename you choose.
> If you choose not, I won't feel hurt and you need not explain...
>
> Best wishes,
>
> Marty B.
>
>
>
>

