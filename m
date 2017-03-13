From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: Parse ICMPv6 redirects
Date: Mon, 13 Mar 2017 14:44:15 +0100
Message-ID: <20170313134415.GA30191@salvia>
References: <1488880843-9352-1-git-send-email-alin.nastac@gmail.com>
 <20170313124050.GA23998@salvia>
 <CAF1oqRDdVPxnpKv4ArDHh0ZJ=4sXuTrMHM=Rzj=WnBe02-xn-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Alin =?utf-8?Q?N=C4=83stac?= <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40120 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751188AbdCMNol (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 09:44:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7896DE56E3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 14:44:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68781DA804
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 14:44:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71742DA7F7
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 14:44:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAF1oqRDdVPxnpKv4ArDHh0ZJ=4sXuTrMHM=Rzj=WnBe02-xn-Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 13, 2017 at 02:17:39PM +0100, Alin Năstac wrote:
> Hi Pablo,
> 
> On Mon, Mar 13, 2017 at 1:40 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Mar 07, 2017 at 11:00:43AM +0100, Alin Nastac wrote:
> >> Extract IPv6 packet that triggered the sending of redirect message from
> >> ICMPv6 Redirected Header option and check if conntrack table contain such
> >> connection. Mark redirect packet as RELATED if a matching connection is found.
> >
> > I think we need a sysctl to enable this on demand, eg.
> > 'nf_conntrack_icmpv6_accept_redirects'
> >
> > This is changing the default behaviour, my main concern here is that
> > filtering policies not accepting redirects will now make it via
> > RELATED.
> 
> net/ipv4/netfilter/nf_conntrack_proto_icmp.c  give RELATED status to
> all ICMP redirect messages that refer to valid conntracks. Why would
> ICMPv6 redirect case be any different?

That's very valid argument, but we have this asymmetry for long time
ago, basically since the beginning. As I said, I have concerns on
changing this default behaviour without an explicit knob. This
behaviour change will go through inadvertently for many people.

> Would you implement a similar sysctl switch for ICMP redirect
> RELATED state? And if you do, would you accept to enable these
> switches by default?

I don't think we shouldn't enable this by default. We have tried to be
conservative on that side so far. Is it a problem there to enable this
via sysctl.conf?

Am I missing any requirement there that is not described in your patch
description?

Thanks.
