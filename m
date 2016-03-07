From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] configure: Show support for connlabel
Date: Mon, 7 Mar 2016 18:56:46 +0100
Message-ID: <20160307175646.GA30910@salvia>
References: <20160307091447.GA10194@gmail.com>
 <20160307140913.GA27599@salvia>
 <CAKHNQQEp7uV+afTfZ73k6srRQyj1ks_dsWYsbu0N_bWzsoNd-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52968 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbcCGR46 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 12:56:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7CE4E4B0F9
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 18:56:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6C94EDA399
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 18:56:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BCB4FDA3A5
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 18:56:51 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQEp7uV+afTfZ73k6srRQyj1ks_dsWYsbu0N_bWzsoNd-Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 11:05:15PM +0530, Shivani Bhardwaj wrote:
> On Mon, Mar 7, 2016 at 7:39 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Mar 07, 2016 at 02:44:47PM +0530, Shivani Bhardwaj wrote:
> >> Add the --enable-connlabel option and show whether it is already
> >> supported.
> >>
> >> After this patch, iptables configuration shows up as:
> >>
> >> Iptables Configuration:
> >>   IPv4 support:                               yes
> >>   IPv6 support:                               yes
> >>   Devel support:                      yes
> >>   IPQ support:                                no
> >>   Large file support:                 yes
> >>   BPF utils support:                  no
> >>   nfsynproxy util support:            no
> >>   nftables support:                   yes
> >>   connlabel support:                  yes
> >>
> >> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> >> ---
> >>  configure.ac | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/configure.ac b/configure.ac
> >> index 33a8f2d..c946d69 100644
> >> --- a/configure.ac
> >> +++ b/configure.ac
> >> @@ -63,6 +63,9 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
> >>  AC_ARG_ENABLE([nftables],
> >>       AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
> >>       [enable_nftables="$enableval"], [enable_nftables="yes"])
> >> +AC_ARG_ENABLE([connlabel],
> >> +     AS_HELP_STRING([--enable-connlabel], [Build libnetfilter_conntrack]),
> >> +     [enable_connlabel="$enableval"], [enable_connlabel="yes"])
> >
> > I think there is still some missing code here. If the user requests
> > connlabel but libnetfilter_conntrack (including the right version) is
> > not available, then I would fail and display an error since the user
> > is explicitly asking for this.
> >
> > Otherwise, we can fall back on the existing behaviour: just lazy check
> > if it's there and enable it in that case. If the library is not
> > present, just skip this.
> >
> > The --disable-connlabel should also work, in that case, we should skip
> > adding support for this.
> >
> > Can you look into fitting this logic into this? Thanks.
> >
> Yes, I'll do that.
> I need a bit of help here.
> I followed some other modules for which support has been mentioned.
> For example, libipq
> When I first ran the configure script, it turned out
> IPQ support:                          no
> 
> I did next time with the option --enable-libipq
> As expected,
> IPQ support:                          yes
> 
> But, I tried writing the output of both these cases to files and when
> I looked up for difference between the two, turned out only this IPQ
> support line was different among them, in any case following was shown
> 
>  config.status: creating libipq/Makefile
>  config.status: creating libipq/libipq.pc
> 
> (because this is a part of AC_CONFIG_FILES)
> 
> I do not see any code associated with libipq in configure.ac.
> May be I'm not understanding how these options are working, could you
> please clarify a bit?

Those are the userspace bits for the old ip_queue support that was
removed years ago, since NFQUEUE superseded for many years.

commit d16cf20e2f2f13411eece7f7fb72c17d141c4a84
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue May 8 19:45:28 2012 +0200

    netfilter: remove ip_queue support

You can still cd iptables/libipq and type 'make' to compile the
this small userspace library since we have to keep new iptables
releases running with old kernels.
