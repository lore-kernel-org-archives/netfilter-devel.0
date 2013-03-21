From: =?UTF-8?Q?Nicolas_Ma=C3=AEtre?= <nimai@skynet.be>
Subject: Drop a packet while keeping the conntrack alive
Date: Thu, 21 Mar 2013 01:57:33 +0100
Message-ID: <CACd4Q01yBxCJo8XcvY8+_HDqkuQG9Zz7=x6BGKdGCh7MA2oFHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55387 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3CUA5y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:57:54 -0400
Received: by mail-qa0-f46.google.com with SMTP id k4so25650qaq.5
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2013 17:57:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've developed a connection tracking module which I'd like to use for
detecting packets that may be dropped with an iptables rule.
That is, the connection tracker can detect that a packet is not  valid
in the context of the tracked connection. So, I'd like the
administrator to be able to add a rule that would allow to drop/reject
that packet.
A possible use case is to block packets from an attacker (assumed as
such as the packet is not conform considering the current state of the
connection).

As far as I understand it, the connection tracker usually handle this
by returning a negative/null value (-NF_ACCEPT, NF_DROP, ...) which
marks the packet invalid, so that it is possible to use the
xt_conntrack extension to match it.

I've looked at the TCP connection tracker. If I understand well, the
current behavior is that if we've got an INVALID packet, it kills the
conntrack, then create it again if we see an ACK later on. Am I right?

That is, it seems that by any way we invalidate a packet, it always
destroy the conntrack so that we haven't the connection state at our
disposal anymore. I would like to avoid that for the protocol I track.
Is there a way to do so? Am I missing something?



Thank you.

--
nimai
