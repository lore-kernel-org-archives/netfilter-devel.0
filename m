From: "Maarten Wijnants" <maarten.wijnants@pandora.be>
Subject: ipq_set_verdict gives errors for multicast packets but works fine
	for unicast (kernel 2.6)
Date: Thu, 6 Jan 2005 12:58:13 +0100
Message-ID: <00d501c4f3e7$00229d80$642813ac@in.edm.luc.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello group,

I have written a libipq application that accepts QUEUEd packets from 
kernelspace, checks them, and subsequently decides what to do with them. I 
often change stuff inside a packet and then reinject it in the kernel 
through ACCEPT. More specifically, I often need to change the source IP and 
source port of UDP packets. Every time I change the content of a QUEUEd UDP 
packet, I recompute the IP checksum, and I set the UDP checksum to 0. The
 UDP checksum is optional (see RFC), so can be set to 0.

 This all worked fine on kernel version 2.4.20. However, I have just 
upgraded to kernel 2.6.6, and all of a sudden my application doesn't work 
anymore. First I thought this was because of the UDP checksum of 0 (see my 
previous mail to the mailinglist). So I implemented an algorithm that 
calculates the UDP checksum, but the problem persists. More specifically, 
when I want to
 reinject an altered packet, I use the following rule of C code:

 ipq_set_verdict(ipq_handle, m->packet_id, NF_ACCEPT, m->data_len, packet);

 Since I didn't change the payload of the UDP packet, only some header 
information, I can use the original size of the QUEUEd packet (i.e. 
m->data_len with m being an ipq_packet_msg_t pointer). Now the strange thing 
is, if the packet is destined for a unicast destination, this line of code 
works and the packet reaches its destination. However, if this packet has a
 multicast destination, it seems to get lost. The result from 
ipq_set_verdict is positive, but the packet doesn't reach its destination. 
What's more, if I tcpdump on the host that issued the NF_ACCEPT verdict, I 
can't see the multicast packet getting sent. The above rule of code worked 
for both unicast and multicast destinations in kernel 2.4.20 ...

 Anyone got any idea what is wrong here? Are there issues with ip_queue in 
combination with kernel 2.6? If anyone got any clues please help me, I am 
getting kind of desperate here :/

 Kind regards,
Maarten

--

Maarten Wijnants
Expertisecentrum voor Digitale Media
Limburgs Universitair Centrum
Wetenschapspark 2 - 3590 Diepenbeek
Tel: +32 (0)11 268419 - Mobile: +32 (0)497 341848
E-mail: maarten.wijnants@luc.ac.be
URL: http://research.edm.luc.ac.be/~mwijnants/ 
