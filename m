From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Mon, 16 Nov 2015 18:03:26 +0100
Message-ID: <20151116170325.GA1694@salvia>
References: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
 <20151116111720.GA14988@salvia>
 <CAOkSjBgG7pVyP1LT0p+cbjrHkTGXRB=KPnrAVNQHSVSXys0xfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38244 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbbKPRDe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 12:03:34 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AD48211D90E
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 18:03:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A012B1788ED
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 18:03:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3DC161788FE
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 18:03:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgG7pVyP1LT0p+cbjrHkTGXRB=KPnrAVNQHSVSXys0xfw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 16, 2015 at 03:22:21PM +0100, Arturo Borrero Gonzalez wrote:
> On 16 November 2015 at 12:17, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Nov 13, 2015 at 11:59:35AM +0100, Arturo Borrero Gonzalez wrote:
> >> v2: change functions definitions to static inline if no BUILD_SYSTEMD,
> >>     and set watchdog variables as static.
> >>
> >> v3: add runtime systemd configuration. Report warnings.
> >
> > One more question:
> >
> > This is checking for 'libsystemd >= 227'
> >
> > Is this library version really required? Or it is simply that you have
> > set to the most recent version for some reason?
> 
> 227 is the version I've tested. Previous versions may not work.
> 
> For example, I remember the library being split in several small
> libraries and then mixed into this libsystemd, thus changing some
> headers and include paths.
> 
> Also, I simply ignore what is the behaviour of the watchdog stuff
> previous to 227, it seems a recent thing.
> 
> What are your concerns?

I would like not to see many ifdefs in the conntrack-tools tree just
because they update interfaces too frequently. Could you check at
their history record to see how they have been performing on that
front so far?

Thanks.
