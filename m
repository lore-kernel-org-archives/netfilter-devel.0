From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] configure: Show support for connlabel
Date: Wed, 16 Mar 2016 19:30:37 +0100
Message-ID: <20160316183037.GA4627@salvia>
References: <20160312121804.GA27150@gmail.com>
 <20160315003601.GA23295@salvia>
 <CAKHNQQHQjiHE26UwYWGPKr+baDftxymBjmr9mJF5mepQBr8+QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49330 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934996AbcCPSao (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 14:30:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E299AC1268
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 19:30:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D3810DA383
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 19:30:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E3F55DA380
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 19:30:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQHQjiHE26UwYWGPKr+baDftxymBjmr9mJF5mepQBr8+QA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2016 at 12:32:51AM +0530, Shivani Bhardwaj wrote:
> On Tue, Mar 15, 2016 at 6:06 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> +if test "x$enable_connlabel" = "xyes"; then
> >> +     PKG_CHECK_MODULES([libnetfilter_conntrack],
> >> +             [libnetfilter_conntrack >= 1.0.4],
> >> +             [nfconntrack=1], [nfconntrack=0])
> >> +
> >> +     if test "$nfconntrack" -ne 1; then
> >> +             blacklist_modules="$blacklist_modules connlabel";
> >> +             echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
> >
> > Could you set enable_connlabel to "no" when this occurs so the banner
> > also displays that connlabel support has been skipped?
> >
> OK. Thanks.
> One question, in case of nftables, I see enable_nftables is nowhere
> set to "no", should that be added in case package requirements are not
> met?

$ ./configure --prefix=/usr --disable-nftables
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
...
Iptables Configuration:
  IPv4 support:                         yes
  IPv6 support:                         yes
  Devel support:                        yes
  IPQ support:                          no
  Large file support:                   yes
  BPF utils support:                    no
  nfsynproxy util support:              no
  nftables support:                     no <------
  connlabel support:                    yes

It says "no" when explicitly disabled. Note that the connlabel case
was special with regards to others, since it didn't ask for explicit
disable/enable in first place.

> Same for bpfc and nfsynproxy.

I can see here these:

--disable-nfsynproxy --disable-bpf-compiler

show "no" in the configuration message.
