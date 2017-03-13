From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: Parse ICMPv6 redirects
Date: Mon, 13 Mar 2017 18:00:54 +0100
Message-ID: <20170313170054.GA32186@salvia>
References: <1488880843-9352-1-git-send-email-alin.nastac@gmail.com>
 <20170313124050.GA23998@salvia>
 <CAF1oqRDdVPxnpKv4ArDHh0ZJ=4sXuTrMHM=Rzj=WnBe02-xn-Q@mail.gmail.com>
 <20170313134415.GA30191@salvia>
 <CAF1oqRD5iMQz+fho4QV0zSyuaAQe61mY4pjuN6oNZ66Ex8DO5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Alin =?utf-8?Q?N=C4=83stac?= <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752148AbdCMRBT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 13:01:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5C6921B2B64
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 18:00:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D1E5DA808
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 18:00:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25CD7DA809
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 18:00:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAF1oqRD5iMQz+fho4QV0zSyuaAQe61mY4pjuN6oNZ66Ex8DO5Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 13, 2017 at 03:17:22PM +0100, Alin Năstac wrote:
> On Mon, Mar 13, 2017 at 2:44 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Mar 13, 2017 at 02:17:39PM +0100, Alin Năstac wrote:
> >> Hi Pablo,
> >>
> >> On Mon, Mar 13, 2017 at 1:40 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> > On Tue, Mar 07, 2017 at 11:00:43AM +0100, Alin Nastac wrote:
> >> >> Extract IPv6 packet that triggered the sending of redirect message from
> >> >> ICMPv6 Redirected Header option and check if conntrack table contain such
> >> >> connection. Mark redirect packet as RELATED if a matching connection is found.
> >> >
> >> > I think we need a sysctl to enable this on demand, eg.
> >> > 'nf_conntrack_icmpv6_accept_redirects'
> >> >
> >> > This is changing the default behaviour, my main concern here is that
> >> > filtering policies not accepting redirects will now make it via
> >> > RELATED.
> >>
> >> net/ipv4/netfilter/nf_conntrack_proto_icmp.c  give RELATED status to
> >> all ICMP redirect messages that refer to valid conntracks. Why would
> >> ICMPv6 redirect case be any different?
> >
> > That's very valid argument, but we have this asymmetry for long time
> > ago, basically since the beginning. As I said, I have concerns on
> > changing this default behaviour without an explicit knob. This
> > behaviour change will go through inadvertently for many people.
> 
> People should not rely on buggy behaviour to keep them safe. Imagine
> for instance there is a bug that prevents packets sent by HTTP servers
> to match "-m conntrack --state ESTABLISHED" rules. Would you add a fix
> that is operational only when an obscure procfs knob gets enabled?

Come on, this behaviour has been there for more than 10 years...

> Redirects are supposed to be sent to on-link hosts, so all we want in
> fact is to allow these packets on INPUT. Would it be OK to restrict
> RELATED status to redirects originated from link-local addresses? This
> will be in line with RFC 4861 requirement that source address of
> ICMPv6 redirects must be in link-local scope.

I think restricting this to link-local, if possible, would be fine.

> >> Would you implement a similar sysctl switch for ICMP redirect
> >> RELATED state? And if you do, would you accept to enable these
> >> switches by default?
> >
> > I don't think we shouldn't enable this by default. We have tried to be
> > conservative on that side so far. Is it a problem there to enable this
> > via sysctl.conf?
> 
> Nothing except that netfilter will still fail to find ICMPv6 redirects
> as RELATED unless you know where to look. Those who want to allow
> redirects will likely allow them explicitly rather than take the
> trouble to find the switch in the procfs.

We can play games on predicting what people will do.

However, fact is that we have not handled icmpv6 nd-redirect as
RELATED for more than 10 years, so I think this behaviour qualifies as
feature not as bug ;).

Look at this from a different angle: User A upgrades its old kernel
with stateful ip6tables ruleset, things will start working in a
different way with no prior advice. That is not good.

A patch for iptables manpage would be good too to document this.
