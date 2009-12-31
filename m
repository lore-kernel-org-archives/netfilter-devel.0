From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack event missing TCP protoinfo
Date: Thu, 31 Dec 2009 19:09:34 +0100
Message-ID: <4B3CE8DE.4020701@netfilter.org>
References: <200912311403.21983.rui.p.m.sousa@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Rui Sousa <rui.p.m.sousa@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60986 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZLaSJT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:09:19 -0500
In-Reply-To: <200912311403.21983.rui.p.m.sousa@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Rui Sousa wrote:
> Hi all,
> 
> Under some conditions it's possible to send a conntrack netlink event to 
> userspace which is missing the TCP connection state 
> (CDA_PROTOINFO_TCP_STATE) even though it is well defined.
> This one liner should fix the problem. What do you think?

I see, I had to look at the code to find the condition that you mention, 
that it is the following:

if (!test_bit(IPS_ASSURED_BIT, &ct->status)
     && (old_state == TCP_CONNTRACK_SYN_RECV
         || old_state == TCP_CONNTRACK_ESTABLISHED)
     && new_state == TCP_CONNTRACK_ESTABLISHED)
        /* Set ASSURED if we see see valid ack in ESTABLISHED
           after SYN_RECV or a valid answer for a picked up
           connection. */

However, the policy is to include the TCP protocol state iff it has changed.
