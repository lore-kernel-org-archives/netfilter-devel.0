From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Tue, 17 Nov 2015 11:25:20 +0100
Message-ID: <20151117102520.GA16690@salvia>
References: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
 <20151116111720.GA14988@salvia>
 <CAOkSjBgG7pVyP1LT0p+cbjrHkTGXRB=KPnrAVNQHSVSXys0xfw@mail.gmail.com>
 <20151116170325.GA1694@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47588 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbbKQKZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2015 05:25:25 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4FA2E6E40C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 11:25:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 400031BC636
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 11:25:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F1E411BC636
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 11:25:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151116170325.GA1694@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 16, 2015 at 06:03:25PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 16, 2015 at 03:22:21PM +0100, Arturo Borrero Gonzalez wrote:
> > On 16 November 2015 at 12:17, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Fri, Nov 13, 2015 at 11:59:35AM +0100, Arturo Borrero Gonzalez wrote:
> > >> v2: change functions definitions to static inline if no BUILD_SYSTEMD,
> > >>     and set watchdog variables as static.
> > >>
> > >> v3: add runtime systemd configuration. Report warnings.
> > >
> > > One more question:
> > >
> > > This is checking for 'libsystemd >= 227'
> > >
> > > Is this library version really required? Or it is simply that you have
> > > set to the most recent version for some reason?
> > 
> > 227 is the version I've tested. Previous versions may not work.
> > 
> > For example, I remember the library being split in several small
> > libraries and then mixed into this libsystemd, thus changing some
> > headers and include paths.
> > 
> > Also, I simply ignore what is the behaviour of the watchdog stuff
> > previous to 227, it seems a recent thing.
> > 
> > What are your concerns?
> 
> I would like not to see many ifdefs in the conntrack-tools tree just
> because they update interfaces too frequently. Could you check at
> their history record to see how they have been performing on that
> front so far?

Arturo, I'm going to push this into master.

I have just mangled the configure.ac part of your patch here so the
default behaviour is that you have to explicitly indicate
--enable-systemd support if you want this.

We can revisit this later on to change the default.

OK?
