From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: (SOLVED) libipq and ipq_packet_msg_t (desperate)
Date: Thu, 16 Dec 2004 09:27:11 -0600
Message-ID: <OFF65A26C7.8CCA41E8-ON86256F6C.004F64D7-86256F6C.0054DBE1@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

First and foremost I would like to thank Ulysses, Srinivas, Henrik, Maarteen for all their help.  If I forgot anyone else thank you 
too!

Below is a code snippet for parsing out the raw packet found in the 
structure ipq_packet_msg_t(ipq_packet_msg_t->payload).  This snippet fits 
into the example from 
http://www.crhc.uiuc.edu/~grier/projects/libipq.html.  I think this would 
useful for people just getting started with LIBIPQ and I wanted to give 
back what I got out.

case IPQM_PACKET: 
 {
  ipq_packet_msg_t *m = ipq_get_packet(buf);
  
  __u16 first_two_bytes = 0; /* hold the first two bytes from payload */
  
  /* Cast the IP Header from the raw packet */
  struct iphdr *iph = ((struct iphdr *)m->payload);
 
  /* Cast the TCP Header from the raw packet */
  struct tcphdr *tcp = (struct tcphdr *)(m->payload + (iph->ihl << 2));    
 
 
  /* get the payload offset from with the raw packet */
  int unsigned payload_offset = ((iph->ihl << 2) + (tcp->doff << 2));
 
  /* calculate the length of the payload */
  int unsigned payload_length = (unsigned int) ntohs(iph->tot_len) - 
((iph->ihl << 2) + (tcp->doff << 2));
 
  /* Calculate the size of the IP  Header.  iph->ihl contains the number 
of 32 bit
     words that represent the header size.  Therfore to get the number of 
bytes
     multiple this number by 4 */
 
 int iphdr_size = (iph->ihl << 2);
 
  /* Calculate the size of the TCP Header.  tcp->doff contains the number 
of 32 bit
     words that represent the header size.  Therfore to get the number of 
bytes
     multiple this number by 4 */
 
 int tcphdr_size = (tcp->doff << 2);
 
 /* get the destination port of the packet */ 
 
 int port = ntohs(tcp->dest); 
 
 /* Get the first two bytes of the payload if a payload is present*/
 if(payload_length)
   first_two_bytes = *(__u16 *) (m->payload + payload_offset);
 
 /* example code */
   if (port == 9555)  /* check for a port match */
     { 
       printf("Matched a packet\n");
 
       if(payload_length) /* if payload_length is zero theres no payload! 
*/ 
        printf("First two bytes: 0x%x\n", first_two_bytes); /* prints in 
HEX */
 
       printf("IP Header size: %d\n", iphdr_size);
       printf("TCP Header size: %d\n", tcphdr_size);
       printf("Payload Size : %d\n", payload_length);
       printf("TOTAL IP Packet size: %d\n", ntohs(iph->tot_len));
       printf("\n");

       status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);      
  
     }
     else
     {
       status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);
       if (status < 0)
         die(h);
     }
       break;
 }


Thanks again!

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)
