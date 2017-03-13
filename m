From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: Re: [PATCH v2] netfilter: Parse ICMPv6 redirects
Date: Mon, 13 Mar 2017 14:17:39 +0100
Message-ID: <CAF1oqRDdVPxnpKv4ArDHh0ZJ=4sXuTrMHM=Rzj=WnBe02-xn-Q@mail.gmail.com>
References: <1488880843-9352-1-git-send-email-alin.nastac@gmail.com> <20170313124050.GA23998@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36577 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752053AbdCMNRn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 09:17:43 -0400
Received: by mail-yw0-f195.google.com with SMTP id 2so9577117ywn.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 06:17:42 -0700 (PDT)
In-Reply-To: <20170313124050.GA23998@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, Mar 13, 2017 at 1:40 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 07, 2017 at 11:00:43AM +0100, Alin Nastac wrote:
>> Extract IPv6 packet that triggered the sending of redirect message from
>> ICMPv6 Redirected Header option and check if conntrack table contain such
>> connection. Mark redirect packet as RELATED if a matching connection is found.
>
> I think we need a sysctl to enable this on demand, eg.
> 'nf_conntrack_icmpv6_accept_redirects'
>
> This is changing the default behaviour, my main concern here is that
> filtering policies not accepting redirects will now make it via
> RELATED.

net/ipv4/netfilter/nf_conntrack_proto_icmp.c  give RELATED status to
all ICMP redirect messages that refer to valid conntracks. Why would
ICMPv6 redirect case be any different? Would you implement a similar
sysctl switch for ICMP redirect RELATED state? And if you do, would
you accept to enable these switches by default?

IMHO ICMPv6 redirects were not included in the original
nf_conntrack_proto_icmpv6.c due to relative complexity of their
format.
