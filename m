From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] src: fix build with musl libc
Date: Mon, 23 Nov 2015 15:43:54 +0100
Message-ID: <20151123144354.GA1063@salvia>
References: <1448254789-30961-1-git-send-email-rprebello@gmail.com>
 <20151123110709.GA5682@salvia>
 <CABLs7GXzpOCuhWJRx8E+2XRX0gjdKVeME1ciSqUy2aSx-NHG1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Rodrigo Rebello <rprebello@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53216 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbbKWOoB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 09:44:01 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8F705FB45F
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 15:43:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7E485DA808
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 15:43:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6A372DA803
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 15:43:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CABLs7GXzpOCuhWJRx8E+2XRX0gjdKVeME1ciSqUy2aSx-NHG1g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 23, 2015 at 11:59:04AM -0200, Rodrigo Rebello wrote:
> Pablo,
> 
> 2015-11-23 9:07 GMT-02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Mon, Nov 23, 2015 at 02:59:49AM -0200, Rodrigo Rebello wrote:
> >> The GNU version of 'struct tcphdr' is not exposed by musl libc headers
> >> unless _GNU_SOURCE is defined. Without this definition, the build fails
> >> with:
> >>
> >>   rpc.c: In function 'rpc_helper_cb':
> >>   rpc.c:351:15: error: 'struct tcphdr' has no member named 'doff'
> >>      offset += th->doff * 4;
> >>                  ^
> >
> > You can probably update the code to use the non-GNU version, that
> > should work both with musl, libc and any other new version that
> > sticks to the standard.
> >
> > Thanks.
> 
> I could change 'doff' to 'th_off' in rpc.c:351, which is the name used
> in the BSD version of 'struct tcphdr', but then I'd have to define the
> macro __FAVOR_BSD in order to get the code to compile with uClibc (in
> contrast to musl, uClibc only exposes the GNU version by default).
> 
> So, I don't see any advantages in doing that (changing the member name
> + defining __FAVOR_BSD) instead of simply defining _GNU_SOURCE.
> Besides, I've noticed that a similar issue has been solved before by
> using the same approach (commit
> fe1f2d58add1e56e651c43de8cd60db8123d49bb).

OK, I have pushed out your patch. Thanks.
