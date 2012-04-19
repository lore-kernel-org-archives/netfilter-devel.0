From: Arif Hossain <aftnix@gmail.com>
Subject: concatenate udp payloads of multiple packet
Date: Thu, 19 Apr 2012 20:32:22 +0600
Message-ID: <CAGuaRCt0Jmj4_prCZVvXi2oijOTprTqUntphjx_9cQqk-nqhCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51698 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2DSOcX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:32:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.

I have a netfilter_queue app which receives packets on a port range
and do modifications on them. Now =A0i need to introduce to new feature=
s
with this basic app.

=46irst the traffic is quiet high. I have seen the --queue-balance
option. If i want to use it how should i approach? i mean should i
manage every queue from separate threads or
separate process to manage individual queues?=A0 I'm not sure how can i
use fork() to manage every queue separately.

Secondly How packets are distributed among different queues? Based on
what property a =A0packet is distributed? Any relationship i need to
know about
this distribution?

Thirdly I need to concatenate udp payloads of several packet to
improve bandwidth usage. how should i approach this? The confusion is
when i stop finish processing
of one packet i call nfq_set_verdict() in nfq_callback().  My
confusion  is when  a packet popped from the NFQUEUE? when
nfq_set_verdict() returns or when nfq_callback()
returns?

I mean if i push the incoming packets in user managed queues for
concatenation of udp payload(by this i will also drop individual
packets), then return from the nfq_callback().
After processing in user managed queues(concatenation is done) then i
will issue nfq_set_verdict(). Would that work?

Thanks in advance.

--
-aft
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
