From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: Re: libipq and ipq_packet_msg_t (desperate)
Date: Wed, 15 Dec 2004 09:33:44 -0600
Message-ID: <OFE4C88EC5.696F51DD-ON86256F6B.005427FA-86256F6B.00557575@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
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

Ulysses, 

That's funny.. I was actually looking at your howto posted at 
http://www.mileniuminformatica.com.br/artigos.php?id=16 at the same time I 
got your email..

Here's a code snippet:


case IPQM_PACKET: {
                    ipq_packet_msg_t *m = ipq_get_packet(buf);
                    struct iphdr *iph = ((struct iphdr *)m->payload);
                          struct tcp = (struct tcphdr *)(m->payload + 
(iph->ihl << 2));
                          char *payload = 
??????????????????????????????????????

Now that I got the ip header, and TCP header.. I am confused on how to get 
to the TCP payload.  Correct me if I am wrong, but the ipq_packet_msg_t 
structure is composed of the complete packet.  e.g. ethernet header, IP 
header, TCP header and data.  So what I need to do is setup offsets from 
the ipq_packet_msg_t->payload to point to each of these areas within the 
packet..

So what I need know is how to get the offset of the payload(data portion). 
 This is where I am stuck.  I also need to find the length of the payload 
section.

Thanks for your reply,

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)




Ulysses Almeida <munky@maluco.com.br>
15/12/2004 11:55 AM

 
        To:     Steven J Scott <sjscott@ra.rockwell.com>
        cc:     netfilter-devel@lists.netfilter.org
        Subject:        Re: libipq and ipq_packet_msg_t (desperate)


Steven,

  If you problem is to find payloadi info and headers, I wrote a HowTo 
about this. http://munky.maluco.com.br/libipq.html.

  Problem, it was wrote in pt_BR. But there is a section called "LibIpq By 
Example", where i show a sample code. And i think it's self explanatory.
  If you have some problems to understand, feel free to ask-me.

  Regards.

On Wed, Dec 15, 2004 at 08:22:27AM -0600, Steven J Scott wrote:
> I am really struggling to extract the payload from the ipq_packet_msg_t 
> structure...  Does anyone have experience in this area???  Or could 
point 
> me to the docs, or people? 
> 
> Thanks,
> 
> Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
> Rockwell Automation / Advanced Technology
> sjscott@ra.rockwell.com
> <---------------------------------------------------->
> (This email was sent via Notes running on Linux)
> 

-- 
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux! 
   ^^-^^
