From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulog2-mysql-schema
Date: Tue, 22 Nov 2011 00:51:05 +0100
Message-ID: <20111121235105.GA14605@1984>
References: <4EC9C0DA.8050705@gmail.com>
 <alpine.LNX.2.01.1111212247580.11993@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: marty <martinbarrowcliff@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, eric@regit.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45853 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab1KUXvJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:51:09 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1111212247580.11993@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 21, 2011 at 10:49:07PM +0100, Jan Engelhardt wrote:
> Cc-forwarding to nf-dev, and Eric and Pablo, who do ulogd2.
> 
> On Monday 2011-11-21 04:09, marty wrote:
> 
> > I use ulog2 to log syslog and packet data to mysql.
> > I parse the data for web display using cron scripts; mostly php.
> > All work very reliably and I really love ulog2 despite it's beta...
> > (but the latest beta was very broken for me. I use orig beta4.)
> >
> > The example MySQL schemas with ulog2 are very complex and problematic, plus
> > have errors and no guidance. Not being updated either...
> >
> > I wrote my own sql to handle logging tcp/udp packets.
> > My schema is quite simple and works fine for me on Linux-3, so I took the time
> > to add some complete tutorial stuff to that sql file.
> > Should make it easier to get ulog/mysql working.
> > I have attached my sql (zipped) to this message, as a donation.
> > Please take a look.
> > If you think this is useful in the ulog docs dir feel free to push
> > it with any filename you choose.
> > If you choose not, I won't feel hurt and you need not explain...

$ ls *.sql
mysql-ulogd2-flat.sql  pgsql-ulogd2-flat.sql
mysql-ulogd2.sql       pgsql-ulogd2.sql

I think mysql-ulogd2-flat.sql is what you want.

Please, use current ulogd2 git snapshot.

I need to find some spare to release final ulogd 2.0, it's ready for
prime time since quite some time, blame me for not having done so
before. I'll try to make it before end of this year.
