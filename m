From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libipq and ipq_packet_msg_t (desperate)
Date: Thu, 16 Dec 2004 08:17:44 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412160812070.27232@filer.marasystems.com>
References: <OF54B1C57F.3AFEF188-ON86256F6B.00596DBF-86256F6B.005B8160@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Maarten Wijnants <maarten.wijnants@pandora.be>,
	netfilter-devel@lists.netfilter.org, Ulysses Almeida <munky@maluco.com.br>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven J Scott <sjscott@ra.rockwell.com>
In-Reply-To: <OF54B1C57F.3AFEF188-ON86256F6B.00596DBF-86256F6B.005B8160@ra.rockwell.com>
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

On Wed, 15 Dec 2004, Steven J Scott wrote:

> Hello Maarten,
>
> Thanks for the clarification of ipq_packet_msg_t and what is consists of.  I had a feeling it didn't contain ethernet
> header.
>
> So to calculate the offset of the payload would look like the following:
>
> struct iphdr *iph = ((struct iphdr *)m->payload);
> struct tcphdr tcp = (struct tcphdr *)(m->payload + (iph->ihl << 2));
>
> char *payload = ( (char*)tcp) + sizeof(struct tcphdr);
> int payload_length = ntohs(iph->tot_len) - ( sizeof(struct tcphdr) +
> sizeof(struct iphdr) );
>
> Is that correct?

No. You need to use the correct header fields, not sizeof. Something like 
the following should work

payload = ((char *)tcp) + (tcp->doff << 2);

payload_length = ntohs(iph->tot_len) - (payload - (char *)iph);

Regards
Henrik
