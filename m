From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] dist: include tests/ directory and files in tarball
Date: Thu, 28 Apr 2016 14:20:52 +0200
Message-ID: <20160428122052.GA2399@salvia>
References: <146183487873.3430.10556920470037312368.stgit@nfdev2.cica.es>
 <20160428092720.GA1848@salvia>
 <CAOkSjBj7FQLjnyWx+rEdLhm47xaGT5YgL-0XjTqZTXeTV630Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58502 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbcD1MYX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 08:24:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 72869C2B1D
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 14:24:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 565101FF909
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 14:24:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01DBA1B60D5
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 14:20:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBj7FQLjnyWx+rEdLhm47xaGT5YgL-0XjTqZTXeTV630Rw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 28, 2016 at 12:07:10PM +0200, Arturo Borrero Gonzalez wrote:
> On 28 April 2016 at 11:27, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Apr 28, 2016 at 11:14:38AM +0200, Arturo Borrero Gonzalez wrote:
> >> If we include tests/ in the release tarball, downstream distributors
> >> can run the testsuites themselves while developing the packages.
> >>
> >> This way, tests can be run in a more integrated environment and they can
> >> discover errors related to the integration with the given distribution itself.
> >>
> >> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> >> ---
> >>  Makefile.am |    2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/Makefile.am b/Makefile.am
> >> index 068009b..10aa40f 100644
> >> --- a/Makefile.am
> >> +++ b/Makefile.am
> >> @@ -4,3 +4,5 @@ SUBDIRS =     src     \
> >>               include \
> >>               doc     \
> >>               files
> >> +
> >> +EXTRA_DIST = tests
> >
> > You can get a git clone instead?
> >
> > This is going to bloat the tarball for something that only a few
> > developer need.
> 
> It seems these are the numbers:
> 
> In the case of nftables
>  * 327K withtout tests
>  * 388K with tests
> 
> In case of conntrack-tools
>  * 496K without tests
>  * 503K with tests
> 
> I don't think this is a big deal.
> 
> Other release tarballs include tests or qa files (libnftnl, ipset,
> libnetfilter-conntrack...)

Right, but libnftnl tests are self-contained (not kernel dependent).

Anyway, nft tests are dependent of the kernel version, given that
we've been augmenting the feature set along the nft development.

So integrating this can be useful to you?
