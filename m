From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Fri, 13 Nov 2015 16:54:31 +0100
Message-ID: <20151113155431.GA1353@salvia>
References: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
 <CAOkSjBim_sssQko+JedaZaa1w=SPVhYKBPvFKW7hGmCFFKXw5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40416 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbbKMPyg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2015 10:54:36 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8133F6E405
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2015 16:54:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 72AE34F0AA
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2015 16:54:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9020E4F0AC
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2015 16:54:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBim_sssQko+JedaZaa1w=SPVhYKBPvFKW7hGmCFFKXw5A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 13, 2015 at 12:39:22PM +0100, Arturo Borrero Gonzalez wrote:
> On 13 November 2015 at 11:59, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > diff --git a/doc/stats/conntrackd.conf b/doc/stats/conntrackd.conf
> > index 16d7a80..b1cca07 100644
> > --- a/doc/stats/conntrackd.conf
> > +++ b/doc/stats/conntrackd.conf
> > @@ -3,6 +3,14 @@
> >  #
> >  General {
> >         #
> > +       # Enable systemd support. If conntrackd is compiled with the proper
> > +       # configuration, you can use a systemd service unit of Type=notify
> > +       # and use conntrackd with systemd watchdog as well.
> > +       # Default is: on
> > +       #
> > +       #Systemd off
> > +
> > +       #
> >         # Set the nice value of the daemon. This value goes from -20
> >         # (most favorable scheduling) to 19 (least favorable). Using a
> >         # negative value reduces the chances to lose state-change events.
> 
> Perhaps it makes sense to factorize all of the conntrackd
> configuration examples in a single man page, let's say
> 'conntrackd.conf(5)'.

Absolutely, a manpage is good to have.
