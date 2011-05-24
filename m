From: Pierre Rondou <prondou@gmail.com>
Subject: icmp_send function broken?
Date: Tue, 24 May 2011 15:09:59 +0200
Message-ID: <4DDBAE27.7020502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, evyncke@cisco.com,
	guy.leduc@ulg.ac.be, Cyril Soldani <cyril.soldani@ulg.ac.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:36433 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756206Ab1EXNJ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 09:09:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm a student at the University of Liege, currently developing a NAT64 
(see RFC 6146) module for Netfilter.

I am using the icmp_send() function in my module to send icmp message in 
case the packet represent an error (like, TTL exceeded or DEST_UNREACHABLE).

But it seems to be broken for me, the dst of the original packet doesn't 
seem to be set.

I'm using 2.6.32-5 kernel to developp, but the function itself didn't 
seem to have been updated in the 2.6.38 kernel.

The modification I had to apply is to re-execute the routing process on 
the incoming paquet in order to get the ICMP packet sent:

    if (!rt)
    {
       memset(&fl, 0, sizeof(fl));
       fl.fl4_dst = oldip->daddr;
       fl.fl4_tos = RT_TOS(oldip->tos);
       fl.proto = skb_in->protocol;

       if (ip_route_output_key(&init_net, &temp, &fl))
          goto out;

       if (!temp)
       {
          pr_info("NAT64: rt null\n");
          goto out;
       }
       rt = temp;
    }

instead of the simple

    if (!rt)
//       goto out;

Is there an other reason why the rtable of the incoming packet was not set?

Regards,

Pierre

