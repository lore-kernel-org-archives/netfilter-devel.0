From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: Re: libipq and ipq_packet_msg_t (desperate)
Date: Wed, 15 Dec 2004 10:39:47 -0600
Message-ID: <OF54B1C57F.3AFEF188-ON86256F6B.00596DBF-86256F6B.005B8160@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Ulysses Almeida <munky@maluco.com.br>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Maarten Wijnants" <maarten.wijnants@pandora.be>
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

Hello Maarten,

Thanks for the clarification of ipq_packet_msg_t and what is consists of.  I had a feeling it didn't contain ethernet 
header.

So to calculate the offset of the payload would look like the following:

struct iphdr *iph = ((struct iphdr *)m->payload);
struct tcphdr tcp = (struct tcphdr *)(m->payload + (iph->ihl << 2));

char *payload = ( (char*)tcp) + sizeof(struct tcphdr);
int payload_length = ntohs(iph->tot_len) - ( sizeof(struct tcphdr) + 
sizeof(struct iphdr) );


Is that correct?
 

Thanks,

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)




"Maarten Wijnants" <maarten.wijnants@pandora.be>
15/12/2004 09:44 AM

 
        To:     "Ulysses Almeida" <munky@maluco.com.br>, "Steven J Scott" 
<sjscott@ra.rockwell.com>
        cc:     <netfilter-devel@lists.netfilter.org>
        Subject:        Re: libipq and ipq_packet_msg_t (desperate)


Hello Steven,

> Now that I got the ip header, and TCP header.. I am confused on how to 
get
> to the TCP payload.  Correct me if I am wrong, but the ipq_packet_msg_t
> structure is composed of the complete packet.  e.g. ethernet header, IP
> header, TCP header and data.

You are correct in the fact that the ipq_packet_msg_t structure contains 
the 
complete packet, but the ethernet header is NOT included. So in the case 
of 
a TCP/IP packet, the payload of the ipq_packet_msg_t structure first 
contains the IP header and then the TCP header and then the (TCP) payload.

> So what I need to do is setup offsets from
> the ipq_packet_msg_t->payload to point to each of these areas within the
> packet..
>
> So what I need know is how to get the offset of the payload(data 
portion).

Well this is exactly what the code snippet shows. You first parse the ip 
header of the packet (with struct iphdr) to retrieve the (variable) length 

of the IP header. You add this amount of bytes to the payload member of 
the 
ipq_packet_msg_t structure. Add this moment, you are pointing to the 
position in the received packet where the TCP header begins. So you parse 
the TCP header (with struct tcphdr) to retrieve the (variable) length of 
the 
TCP header. If you now also add this amount of bytes, you will point to 
the 
payload of your packet.

> I also need to find the length of the payload section.

This information can also be found by parsing the IP header of the packet 
with the struct iphdr. This struct has a member which specifies the total 
length of the IP packet (including headers!!).

Greetings,
Maarten 
