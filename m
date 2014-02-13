From: Daehee Kim <dahkim77@gmail.com>
Subject: How to forward a modified packet by using libnetfilter_queue
Date: Thu, 13 Feb 2014 14:38:13 -0600
Message-ID: <CAHYG+ykgKDBVoDENWaM1998qy95aWz47xN4haHBPPxuTcwJPRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54723 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBMUiN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:38:13 -0500
Received: by mail-pa0-f41.google.com with SMTP id fa1so11338651pad.28
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2014 12:38:13 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I want to forward a packet modified by libnetfilter_queue.

In detail, suppose a TCP packet is delivered from host1 to host2 as followings.

host1 ---> server --> host2

Here, a server is connected both to host1 and to host2. (to two NICs)
First, host1 sends a TCP packet for host2.
When a packet comes into server, the server modifies the packet(header
or payload).
Then, the server forwards the modified packet to host2.

----------------------------------------------------------
I know how to intercept incoming packet at a server by iptables and
netfilter_queue, but I don't know how to forward the modified packet
to host2.

In detail, I create a NFQUEUE using iptables and I use modified
"nfqnl_test.c" to intercept and modify a packet. Problem is how to
forward the modified packet to an original destination of the packet
(In above scenario, to host2)

Should I add some filter rules with iptables or should I add some
codes in "nfqnl_test.c" ?

Any suggestions would be helpful for me.
Thanks in advance.

Danny
