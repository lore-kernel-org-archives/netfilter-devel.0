From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: Re: libipq and ipq_packet_msg_t (desperate)
Date: Wed, 15 Dec 2004 08:22:27 -0600
Message-ID: <OF155D7334.0CB5B8D1-ON86256F6B.004EC35F-86256F6B.004EEEA3@ra.rockwell.com>
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

I am really struggling to extract the payload from the ipq_packet_msg_t 
structure...  Does anyone have experience in this area???  Or could point 
me to the docs, or people? 

Thanks,

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)




Steven J Scott <sjscott@ra.rockwell.com>
Sent by: netfilter-devel-bounces@lists.netfilter.org
13/12/2004 12:27 PM

 
        To:     netfilter-devel@lists.netfilter.org
        cc: 
        Subject:        libipq and ipq_packet_msg_t


Hello,

I am trying to parse the first two bytes of the payload of a TCP packet. 
Am I casting the payload part of the TCP packet right?  Below is the code 
in question.


case IPQM_PACKET: {
                     ipq_packet_msg_t *m = ipq_get_packet(buf);

                     struct iphdr *ip = (struct iphdr*) m->payload;

                     struct tcphdr *tcp = (struct tcphdr*) (m->payload + 
(4 * ip->ihl));
 
                     char *data = (char *)((int32_t *)tcp + tcp->doff);
 
 
                     __u16 command = *(__u16 *) data;
 
 
                         printf("COMMAND: %d\n",ntohs(command) );
 
                     printf("Len data : %d\n", ntohs(m->data_len));
 
                     status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 
0, NULL); 
 
                     }
 

Thanks,

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)
