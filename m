From: "Maarten Wijnants" <maarten.wijnants@pandora.be>
Subject: Re: libipq and ipq_packet_msg_t (desperate)
Date: Wed, 15 Dec 2004 16:44:55 +0100
Message-ID: <005801c4e2bd$06fda900$6c2813ac@in.edm.luc.ac.be>
References: <OFE4C88EC5.696F51DD-ON86256F6B.005427FA-86256F6B.00557575@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Ulysses Almeida" <munky@maluco.com.br>,
	"Steven J Scott" <sjscott@ra.rockwell.com>
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

Hello Steven,

> Now that I got the ip header, and TCP header.. I am confused on how to get
> to the TCP payload.  Correct me if I am wrong, but the ipq_packet_msg_t
> structure is composed of the complete packet.  e.g. ethernet header, IP
> header, TCP header and data.

You are correct in the fact that the ipq_packet_msg_t structure contains the 
complete packet, but the ethernet header is NOT included. So in the case of 
a TCP/IP packet, the payload of the ipq_packet_msg_t structure first 
contains the IP header and then the TCP header and then the (TCP) payload.

> So what I need to do is setup offsets from
> the ipq_packet_msg_t->payload to point to each of these areas within the
> packet..
>
> So what I need know is how to get the offset of the payload(data portion).

Well this is exactly what the code snippet shows. You first parse the ip 
header of the packet (with struct iphdr) to retrieve the (variable) length 
of the IP header. You add this amount of bytes to the payload member of the 
ipq_packet_msg_t structure. Add this moment, you are pointing to the 
position in the received packet where the TCP header begins. So you parse 
the TCP header (with struct tcphdr) to retrieve the (variable) length of the 
TCP header. If you now also add this amount of bytes, you will point to the 
payload of your packet.

> I also need to find the length of the payload section.

This information can also be found by parsing the IP header of the packet 
with the struct iphdr. This struct has a member which specifies the total 
length of the IP packet (including headers!!).

Greetings,
Maarten 
