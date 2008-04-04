From: Bhaskar <vbhaskar@rocsys.com>
Subject: What does SPI firewall Mean?
Date: Fri, 04 Apr 2008 13:02:55 +0530
Message-ID: <47F5D9A7.4000403@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp109.biz.mail.mud.yahoo.com ([68.142.201.178]:39396 "HELO
	smtp109.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752160AbYDDHhi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:37:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
I have been thinking about this questions.  The obvious answer I got is
SPI firewall understands the states of the packet flow and maintains the
states, TCP is the main protocol for statefull packet flow.

I am testing netfilter firewall with simple setup and the Linux kernel I
am using is 2.6.21.2.  Here is the Setup:

       <PC>-----------------------------<Linux Router with
Netfilter>-------------------------<ISP>
                 <Protected
NW>                                                               <WAN NW>

              
Following are the policies added in Linux Router:

Policies in Filter Table:

   1. iptables -A FORWARD -i eth0 -o eth1 -p tcp -m state --state
      NEW,ESTABLISHED --dport 80 -j ACCEPT
   2. iptabgles -A FORWARD -i eth0 -o eth1 -p udp -m udp --dport 53 -j
      ACCEPT
   3. iptables -A FORWARD -j LOG --log-prefix "Dropping Other Packets:"
   4. iptables -A FORWARD -j DROP

Both INPUT and OUTPUT chains have DROP policy


Policies in NAT Table:

   1. iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

The intension is to allow HTTP Traffic to the internal network.  With
the above setup I am not able to browse from PC connected in Protected
NW.  After analyzing the Logs and added another 2 policies above Policy
Number 3:
iptables -A FORWARD -i eth1 -o eth0 -p tcp -m state --state
NEW,ESTABLISHED --sport 80 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p udp -m udp --sport 53 -j ACCEPT

After adding these policies I am able to browse.  AFAIK, once an
association is created (first time when packet is passing through
netfilter), the associated traffic would flow and Policies are not
parsed for the verdict.  I am little confused with this behavior.

Can somebody throw some light on this?

I see that /proc/net/nf_conntrack has correct association parameters
with outgoing IP parameters and what is expected.   To my understanding
the above two policies need not be added as Netfilter is already aware
of the reply packets.

Thanks for your response,
-Bhaskar
