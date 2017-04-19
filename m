From: Michael Bailey <strictlymike@gmail.com>
Subject: Mixing tables for NFQUEUE target
Date: Tue, 18 Apr 2017 23:41:12 -0500
Message-ID: <CAKQaGz-3RxG2jVCbyGWUVik9uzpTaMZ5XCg8tnGzgGbWPFyz-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:36346 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdDSElO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 00:41:14 -0400
Received: by mail-qt0-f171.google.com with SMTP id g60so10440476qtd.3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 21:41:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Is there any harm in mangling a packet in an INPUT/mangle hook point
on the way into the system and un-mangling it in the OUTPUT/raw hook
point on the way out? I'll describe my setup, problem, observations,
hypothesis, and the fix. I would be keen to hear if there is a more
orthodox solution.

I have a remote client configured with another machine as its gateway.
On this "gateway", I have IP redirection using:

iptables -t nat -I PREROUTING -j REDIRECT

I'm simultaneously implementing dynamic port forwarding (DPF) using
the NFQUEUE target and python-netfilterqueue. My code mangles packets:
it updates destination port numbers on the way in, refreshes them on
the way out, and always recalculates checksums.

When my DPF code is inactive and the client attempts to talk to an
arbitrary IP, the gateway sends response packets that look like they
come from <arbitrary IP>. The client and gateway finish the three-way
TCP handshake, establish a connection, and exchange information.

But when my port forwarding code _does_ mangle packets, the gateway
sends the SYN,ACK with its own IP address and the TCP three-way
handshake fails with the client sending an RST.

I believed my DPF code in the INPUT/mangle and OUTPUT/mangle hook
points was preventing the system from recognizing response packets, so
I investigated.

Based on xt_REDIRECT.c, nf_nat_redirect.c from Linux 4.9.6, and
looking the module dependencies on my system, my understanding is that
the REDIRECT rule I am using depends upon connection tracking to
calculate a tuple against incoming packets and then calculate an
inverse-tuple to identify and fix up reply packets on their way out of
the OUTPUT/nat hook point. The documentation here seems to describe
some of the tuple/inverse-tuple behavior I saw in the source files,
and says it occurs during the PREROUTING and OUTPUT chains:

http://netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO-4.html

I believe my choice of chains/tables caused the tuple to be calculated
using the original port, and the inverse-tuple to be calculated using
the modified port. Does that sound right?

As a solution, I tried moving my fix-up callback to the OUTPUT/raw
hook location, and it looks as if this allows my NFQUEUE DPF code to
co-exist peacefully with the static REDIRECT rule.

Could I be creating an undesired consequence by mixing tables (mangle
vs. nat), or is this the right answer?

I also saw what looked like a robust library of connection tracking
and NAT code in net/netfilter/nf_conntrack_*.c that looked like it was
for tracking connections for many protocols other than just TCP and
UDP. For instance, nf_conntrack_irc.c. Is that all code that Netfilter
may use to support the REDIRECT rule I created using iptables above,
depending on the protocols that are in use at a given time?

Thanks for any answers you can give,
Michael
