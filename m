From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] configure: Show support for connlabel
Date: Tue, 8 Mar 2016 14:37:58 +0100
Message-ID: <20160308133758.GA5764@salvia>
References: <20160307091447.GA10194@gmail.com>
 <20160307140913.GA27599@salvia>
 <CAKHNQQEp7uV+afTfZ73k6srRQyj1ks_dsWYsbu0N_bWzsoNd-Q@mail.gmail.com>
 <20160307175646.GA30910@salvia>
 <20160307180044.GA4134@salvia>
 <CAKHNQQFEtTkdrT9+f1i2XSG8+nk7ivCZz7bJcJm4tfbtGeCJtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50332 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbcCHNiI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 08:38:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 85BFDED064
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:38:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 76440DA38F
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:38:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6EE15DA38E
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:38:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQFEtTkdrT9+f1i2XSG8+nk7ivCZz7bJcJm4tfbtGeCJtw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 11:36:33PM +0530, Shivani Bhardwaj wrote:
> On Mon, Mar 7, 2016 at 11:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Mar 07, 2016 at 06:56:46PM +0100, Pablo Neira Ayuso wrote:
> >> On Mon, Mar 07, 2016 at 11:05:15PM +0530, Shivani Bhardwaj wrote:
> >> > Yes, I'll do that.
> >> > I need a bit of help here.
> >> > I followed some other modules for which support has been mentioned.
> >> > For example, libipq
> >> > When I first ran the configure script, it turned out
> >> > IPQ support:                          no
> >> >
> >> > I did next time with the option --enable-libipq
> >> > As expected,
> >> > IPQ support:                          yes
> >> >
> >> > But, I tried writing the output of both these cases to files and when
> >> > I looked up for difference between the two, turned out only this IPQ
> >> > support line was different among them, in any case following was shown
> >> >
> >> >  config.status: creating libipq/Makefile
> >> >  config.status: creating libipq/libipq.pc
> >> >
> >> > (because this is a part of AC_CONFIG_FILES)
> >> >
> >> > I do not see any code associated with libipq in configure.ac.
> >> > May be I'm not understanding how these options are working, could you
> >> > please clarify a bit?
> >>
> >> Those are the userspace bits for the old ip_queue support that was
> >> removed years ago, since NFQUEUE superseded for many years.
> >>
> >> commit d16cf20e2f2f13411eece7f7fb72c17d141c4a84
> >> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> >> Date:   Tue May 8 19:45:28 2012 +0200
> >>
> >>     netfilter: remove ip_queue support
> >>
> >> You can still cd iptables/libipq and type 'make' to compile the
> >> this small userspace library since we have to keep new iptables
> >> releases running with old kernels.
> >
> > Oh sorry, now I see.
> >
> > This is always compiling libipq even with --disable-libipq, this looks
> > like a bug in our build infrastructure.
> 
> Yes. Also, I see that devel should have --disable-devel instead of
> --enable-devel option and the appropriate functionality associated
> with it. Please correct me if I am wrong here.

So is --disable-devel also broken / being ignored? If so, that also
needs a fix, yes.
