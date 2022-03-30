Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19922C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 20:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351162AbiC3U7O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 16:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351174AbiC3U7N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 16:59:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB93541637
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 13:57:26 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nZfNb-0007N1-Rg; Wed, 30 Mar 2022 22:57:23 +0200
Date:   Wed, 30 Mar 2022 22:57:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 9/9] extensions: DNAT: Support service names in
 all spots
Message-ID: <YkTEM8r6tv+fkOOK@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220330155851.13249-1-phil@nwl.cc>
 <20220330155851.13249-10-phil@nwl.cc>
 <89qp85o0-704s-5280-sqp6-s71so14n7487@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89qp85o0-704s-5280-sqp6-s71so14n7487@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Wed, Mar 30, 2022 at 08:38:28PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2022-03-30 17:58, Phil Sutter wrote:
> 
> >When parsing (parts of) a port spec, if it doesn't start with a digit,
> >try to find the largest substring getservbyname() accepts.
> 
> > -p tcp -j DNAT --to-destination 1.1.1.1:1000-2000/65536;;FAIL
> > -p tcp -j DNAT --to-destination 1.1.1.1:ssh;-p tcp -j DNAT --to-destination 1.1.1.1:22;OK
> > -p tcp -j DNAT --to-destination 1.1.1.1:ftp-data;-p tcp -j DNAT --to-destination 1.1.1.1:20;OK
> >+-p tcp -j DNAT --to-destination 1.1.1.1:ftp-data-ssh;-p tcp -j DNAT --to-destination 1.1.1.1:20-22;OK
> >+-p tcp -j DNAT --to-destination 1.1.1.1:echo-ftp-data;-p tcp -j DNAT --to-destination 1.1.1.1:7-20;OK
> >+-p tcp -j DNAT --to-destination 1.1.1.1:ftp-data-ssh/echo;-p tcp -j DNAT --to-destination 1.1.1.1:20-22/7;OK
> >+-p tcp -j DNAT --to-destination 1.1.1.1:echo-ftp-data/ssh;-p tcp -j DNAT --to-destination 1.1.1.1:7-20/22;OK
> > -j DNAT;;FAIL
> 
> This looks dangerous. It is why I originally never allowed service names in
> port ranges that use dash as the range character. a-b-c could mean a..b-c
> today, and could mean a-b..c tomorrow, either because someone managed to
> inject a-b into the service list.

Yes, it is a rather sloppy solution. I could at least do a shortest
substring first search in addition to check if the input is ambiguous.

Guess if someone is able to manipulate /etc/services, any service names
are problematic, not just in ranges.

Another potential problem I didn't have in mind though is that 'a-b'
could mean [a; b] or [a-b] assuming that all three exist. But I haven't
found a valid example in my /etc/services, yet. :)

> The "solution" would be to use : as the range character, but that would require
> a new --dport option for reasons of command-line compatibility.

Well, we could allow both (a-b with numeric a and b only) and use it in
output only if non-numeric was requested.

Maybe also just limit service names in DNAT to non-ranges. I wanted to
write "like with REDIRECT before the merge", but it looks like it
accepted them as upper boundary, e.g. '10-ftp-data'.

Hmm. I also noticed my series drops support for port 0 from REDIRECT
which commit 84d758b3bc312 ("extensions: REDIRECT: fix --to-ports
parser") explicitly allowed.

Thanks, Phil
