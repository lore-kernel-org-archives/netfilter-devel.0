From: Pierre Chifflier <chifflier@wzdftpd.net>
Subject: Re: ulog2-mysql-schema
Date: Tue, 22 Nov 2011 10:25:29 +0100
Message-ID: <20111122092528.GC2487@mail.wzdftpd.net>
References: <4EC9C0DA.8050705@gmail.com>
 <alpine.LNX.2.01.1111212247580.11993@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, eric@regit.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.wzdftpd.net ([91.121.80.151]:37358 "EHLO mail.wzdftpd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab1KVJdN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:33:13 -0500
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
> >
> > Best wishes,
> >

Hi,

As Pablo said, I think the schema you want is the -flat one (with one
table).

Your SQL schema was not attached in the forwarded mail from Jan, can you
resend it (to the list, or directly to me if too big) ?

Pierre
