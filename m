Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACA0C07E99
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Jul 2021 18:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BDE61003
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Jul 2021 18:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhGISwI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Jul 2021 14:52:08 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:39212 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGISwI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Jul 2021 14:52:08 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 169ImvZU031484;
        Fri, 9 Jul 2021 20:49:02 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 4357E120F47;
        Fri,  9 Jul 2021 20:48:52 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1625856532; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JMkMGd5GL8sdjjnwXjxWjGYOmi16wwHZHg80axIGzHg=;
        b=X9l0UAwb/XQBGUvy8l7anypclq5273hScM/ZmYkPUiE/E9Ayr9yWKLe7vHq5eZ3zs+pmxx
        SVdcvMOz8DmxdhAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1625856532; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JMkMGd5GL8sdjjnwXjxWjGYOmi16wwHZHg80axIGzHg=;
        b=I9wFfL7xsJ1li9XvhMCqkqza4P4FekEULbWJoFJz8+Vbu3cK/9R9N8H22Ajp8ViekT8uSb
        Pz/sir7j+6uYIUb5z5oOawS7os7IFMHLF+0WezjWcDYBMKsWkwg3xbrOfjMY7AYiA3oY2G
        PgDa1A0XlyqytqN/qsII04zyxgGox0CPWlSu3ZmrddOdjLEjGokerI+cdjYNRI/n4GbTDp
        SABNfjIfiBBklJUlCIRohQY5aoiva9XV7YZHhDwyW5mMkBu4hSzuZVdNcMTvRCPNkCrXhQ
        z4AgBoyq+DTFOvRhQhahgPUfKtZk7z/bK5OUC29zw/ygbj8t85D5Kr0V39RxBA==
Date:   Fri, 9 Jul 2021 20:48:51 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Ryoga Saito <proelbtn@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated
 flows
Message-Id: <20210709204851.90b847c71760aa40668a0971@uniroma2.it>
In-Reply-To: <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
References: <20210706052548.5440-1-proelbtn@gmail.com>
        <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
        <20210708133859.GA6745@salvia>
        <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
        <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
        <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ryoga,
please, see my answers below.

On Fri, 9 Jul 2021 05:52:45 +0900
Ryoga Saito <proelbtn@gmail.com> wrote:

> Dear Andrea
> Thanks for your reviews and comments.
>

You're welcome, always happy to help if I can.


> >
> > the problem is that in SRv6 a packet to be processed by a node with an
> > SRv6 End Behavior does not follow the INPUT path and its processing is
> > different from the UDP tunnel example that you have in mind (more info
> > below)
> >
> > Note that I'm referring to the SRv6 Behaviors as implemented in seg6_local.c
>
> I thought SRv6 processing to be the same as encapsulation/decapsulation
> processing and I implemented patch this way intentionally.
>

Segment routing is *not* just another protocol to carry encapsulated traffic
and, thus, to perform *only* encap/decap operations.

Directly quoting the abstract of the RFC 8986:
  ---
  The Segment Routing over IPv6 (SRv6) Network Programming framework
  enables a network operator or an application to specify a packet
  processing program by encoding a sequence of instructions in the IPv6
  packet header.

  Each instruction is implemented on one or several nodes in the
  network and identified by an SRv6 Segment Identifier in the packet.
  ---

In principle, each instruction can lead to a different processing than the
other.


>
> I considered srv6 Behaviors (e.g. T.Encaps) to be the same as the encapsulation
> in other tunneling protocols, and srv6local Behaviors (e.g. End, End.DT4,
> End.DT6, ...) to be the same as the decapsulation in other tunneling protocols
> even if decapsulation isn't happened. 

This is the point: SRv6 End, End.T, End.X with their flavors are *not* encap/
decap operations. As SRv6 is not a protocol meant only for encap/decap, we
cannot apply to this the same logic found in other protocols that perform
encap/decap operations.


> I'm intended that SRv6 packets whose
> destination address is SRv6 End Behavior go through INPUT path.
>

No, it does not work this way and this was an important design choice in the
SRv6 implementation in Linux. Basically, the SIDs corresponding to End
behaviors (srv6local) are *not* considered local addresses bound to a local
interface. This has important advantages in terms of the forwarding performance
of SRv6. We cannot change this design choice without causing a strong
performance impact on SRv6 forwarding.


> I think it works correctly on your situation with the following rule:
>
> ip6tables -A INPUT --dst fc01::2 -j ACCEPT
>
> To say more generally, SRv6 locator blocks should be allowed with ip6tables if
> you want to change default policy of INPUT chain to DROP/REJECT.
>  

No, this is a way to fix the problem that you introduce by changing the current
srv6local forwarding model. If you have 100 End SIDs should you add 100 accept
rules? The root problem is that SRv6 (srv6local) traffic should not go through
the INPUT path.

Have you set the traffic to flow through INPUT to confirm a connection (for
conntrack)? If this is the only reason, before changing the srv6local
processing model in such a disruptive way, you can investigate different ways
to do connection confirmation without going directly through nfhook with INPUT.
I can help with some hints if you are interested.

Andrea
