From: Rui Sousa <rui.p.m.sousa@gmail.com>
Subject: Re: [PATCH] conntrack event missing TCP protoinfo
Date: Mon, 4 Jan 2010 19:03:21 +0100
Message-ID: <201001041903.21755.rui.p.m.sousa@gmail.com>
References: <200912311403.21983.rui.p.m.sousa@gmail.com> <4B3CE8DE.4020701@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35151 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0ADSD2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:03:28 -0500
Received: by ewy19 with SMTP id 19so7557431ewy.21
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2010 10:03:26 -0800 (PST)
In-Reply-To: <4B3CE8DE.4020701@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 31 December 2009 19:09:34 Pablo Neira Ayuso wrote:
> Hi,

Hi Pablo,

> Rui Sousa wrote:
> > Hi all,
> >
> > Under some conditions it's possible to send a conntrack netlink event to
> > userspace which is missing the TCP connection state
> > (CDA_PROTOINFO_TCP_STATE) even though it is well defined.
> > This one liner should fix the problem. What do you think?
>
> I see, I had to look at the code to find the condition that you mention,
> that it is the following:
>
> if (!test_bit(IPS_ASSURED_BIT, &ct->status)
>      && (old_state == TCP_CONNTRACK_SYN_RECV
>
>          || old_state == TCP_CONNTRACK_ESTABLISHED)
>
>      && new_state == TCP_CONNTRACK_ESTABLISHED)
>         /* Set ASSURED if we see see valid ack in ESTABLISHED
>            after SYN_RECV or a valid answer for a picked up
>            connection. */

I believe so, but I having a hard time understanding what I'm seeing.
AFAICT, I'm exercising the state transition sNo->sES->sES, my procedure is:

PC1 -> linux router -> PC2

1. establish TCP connection between two PC's (using iperf). PC1 is the client, 
PC2 is the server.
2. On the router, ifdown of output interface (the interface on PC2 side)
3. On the router, manual destroy of connection in kernel
4. On the router, ifup of output interface
5. wait for iperf to start sending packets again. The connection between the 
endpoints is always established.

Between 3 and 4 I receive a NFCT_DESTROY event (from libnetfilter_conntrack).
During 5. I get two events, both NFCT_UPDATEs, the first with conntrack status 
CONFIRMED/SEEN_REPLY, the second with conntrack status ASSURED. Both are 
missing the TCP protoinfo. In this is my problem, the kernel correctly picked 
up the on going TCP connection but never sends enough information to 
userspace about it.

> However, the policy is to include the TCP protocol state iff it has
> changed.

But in my case it does change and I never get a protocol state indication.

Br,
Rui
