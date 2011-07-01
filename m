From: Nader Al-Naji <nbal@princeton.edu>
Subject: Send Packets In Prerouting?
Date: Fri, 01 Jul 2011 12:33:18 -0400
Message-ID: <38209.1309537998@princeton.edu>
Reply-To: nbal@princeton.edu
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ppa04.Princeton.EDU ([128.112.128.215]:39126 "EHLO
	ppa04.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab1GAQmO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:42:14 -0400
Received: from csgsmtp200l.Princeton.EDU (csgsmtp200l.Princeton.EDU [128.112.130.131])
	by ppa04.Princeton.EDU (8.14.4/8.14.4) with ESMTP id p61GXIlT007703
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Fri, 1 Jul 2011 12:33:18 -0400
Received: from webmail.princeton.edu (atmail01.Princeton.EDU [128.112.133.236])
	by csgsmtp200l.Princeton.EDU (8.13.8/8.12.9) with ESMTP id p61GXIP0019562
	for <netfilter-devel@vger.kernel.org>; Fri, 1 Jul 2011 12:33:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, I'm writing a prerouting hook module that modifies packets and sends them back to the source without letting the higher layers know anything about it. Using tcpdump, I see that everything works fine except for the fact that the ethernet header is written incorrectly by dev_queue_xmit. Before I call dev_queue_xmit, the ethernet header is set to zero-- but then it goes writes in the same source/dest as were on it when the packet arrived, and it shouldn't because I manually change the IP's in my hook. I have no idea how macs are chosen even from close inspection of the code for dev_queue_xmit and friends. I thought it would inspect the packet's reversed IP addresses to see which macs to put in before sending it off but this isn't happening as I expect it to. Am I missing something here
 ? Are there some fields I should set in the sk_buff to let dev_queue_xmit know that it needs to inspect the IP addresses in the packet before choosing/finding MAC addresses? 

Here is an abbreviation of the offending code:

//The main hook function
static unsigned int myhook_in_func(unsigned int hooknum,
		struct sk_buff *skb,
		const struct net_device *in,
		const struct net_device *out,
		int (*okfn)(struct sk_buff *))
{
                ......
                MAKE MODIFICATIONS TO THE PACKET HERE INCLUDING CHANGING IP'S
                ......		


                //The ethernet header is zero at this point-- I checked.
                skb_push(skb, ETH_HLEN);
	
                //Set the packet type to outgoing-- didn't help.
	       skb->pkt_type = PACKET_OUTGOING;
		
                //Send the packet on the wire; ARP resolution is done somewhere in here..				
		dev_queue_xmit(skb);

                //NF_STOLEN because dev_queue_xmit consumes the skb
                return NF_STOLEN;
}

The hook is registered in NF_IP_PRE_ROUTING. 

Thanks in advance for your help!
--Nader Al-Naji

PS: Wasn't sure whether to post this in the netfilter user list (instead of development) but after reading their questions, it seems to me that this is really more of a development-oriented issue. Please let me know if these kinds of questions actually belong more in the user list.


