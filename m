From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] configure: exit if libnftnl is not found
Date: Wed, 13 Apr 2016 01:27:53 +0200
Message-ID: <20160412232753.GA21546@salvia>
References: <1459073146-11576-1-git-send-email-giuseppelng@gmail.com>
 <20160408125536.GA8693@salvia>
 <CAFpD06RfmQe5gJO_VJo=2Ke-JqN3yMkge8xeEA0VNzy_uypSpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37966 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964933AbcDLX2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 19:28:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 664F4C9EE1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:28:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 55E92AD87
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:28:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D544DDA792
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:27:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAFpD06RfmQe5gJO_VJo=2Ke-JqN3yMkge8xeEA0VNzy_uypSpQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 09, 2016 at 10:46:40AM +0200, Giuseppe Longo wrote:
> >> @@ -128,6 +128,13 @@ if test "x$enable_nftables" = "xyes"; then
> >>
> >>       PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0.5], [nftables=1], [nftables=0])
> >>
> >> +     if test "$nftables" = 0;
> >> +     then
> >> +             echo "*** Error: No suitable libnftnl found. ***"
> >> +             echo "    Please install the 'libnftnl' package."
> >
> > I'm going to take this patch, but mangle it to include this information too:
> >
> >                 echo "    Or consider --disable-nftables to skip "
> >                 echo "    iptables-compat over nftables support."
> >
> 
> I can send a v2 of this patch with these changes.
> I think a similar patch is needed for libmnl because
> there is a same issue.

Fine with me, I'd appreciate if you send a v2. Thanks!
