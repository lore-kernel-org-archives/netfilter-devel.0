From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: Re: [PATCH v2] netfilter: Parse ICMPv6 redirects
Date: Mon, 13 Mar 2017 15:17:22 +0100
Message-ID: <CAF1oqRD5iMQz+fho4QV0zSyuaAQe61mY4pjuN6oNZ66Ex8DO5Q@mail.gmail.com>
References: <1488880843-9352-1-git-send-email-alin.nastac@gmail.com>
 <20170313124050.GA23998@salvia> <CAF1oqRDdVPxnpKv4ArDHh0ZJ=4sXuTrMHM=Rzj=WnBe02-xn-Q@mail.gmail.com>
 <20170313134415.GA30191@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35723 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753362AbdCMORa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 10:17:30 -0400
Received: by mail-yw0-f196.google.com with SMTP id h11so9775157ywa.2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 07:17:29 -0700 (PDT)
In-Reply-To: <20170313134415.GA30191@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 13, 2017 at 2:44 PM, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
> On Mon, Mar 13, 2017 at 02:17:39PM +0100, Alin N=C4=83stac wrote:
>> Hi Pablo,
>>
>> On Mon, Mar 13, 2017 at 1:40 PM, Pablo Neira Ayuso <pablo@netfilter.org>=
 wrote:
>> > On Tue, Mar 07, 2017 at 11:00:43AM +0100, Alin Nastac wrote:
>> >> Extract IPv6 packet that triggered the sending of redirect message fr=
om
>> >> ICMPv6 Redirected Header option and check if conntrack table contain =
such
>> >> connection. Mark redirect packet as RELATED if a matching connection =
is found.
>> >
>> > I think we need a sysctl to enable this on demand, eg.
>> > 'nf_conntrack_icmpv6_accept_redirects'
>> >
>> > This is changing the default behaviour, my main concern here is that
>> > filtering policies not accepting redirects will now make it via
>> > RELATED.
>>
>> net/ipv4/netfilter/nf_conntrack_proto_icmp.c  give RELATED status to
>> all ICMP redirect messages that refer to valid conntracks. Why would
>> ICMPv6 redirect case be any different?
>
> That's very valid argument, but we have this asymmetry for long time
> ago, basically since the beginning. As I said, I have concerns on
> changing this default behaviour without an explicit knob. This
> behaviour change will go through inadvertently for many people.

People should not rely on buggy behaviour to keep them safe. Imagine
for instance there is a bug that prevents packets sent by HTTP servers
to match "-m conntrack --state ESTABLISHED" rules. Would you add a fix
that is operational only when an obscure procfs knob gets enabled?

Redirects are supposed to be sent to on-link hosts, so all we want in
fact is to allow these packets on INPUT. Would it be OK to restrict
RELATED status to redirects originated from link-local addresses? This
will be in line with RFC 4861 requirement that source address of
ICMPv6 redirects must be in link-local scope.

>> Would you implement a similar sysctl switch for ICMP redirect
>> RELATED state? And if you do, would you accept to enable these
>> switches by default?
>
> I don't think we shouldn't enable this by default. We have tried to be
> conservative on that side so far. Is it a problem there to enable this
> via sysctl.conf?

Nothing except that netfilter will still fail to find ICMPv6 redirects
as RELATED unless you know where to look. Those who want to allow
redirects will likely allow them explicitly rather than take the
trouble to find the switch in the procfs.
