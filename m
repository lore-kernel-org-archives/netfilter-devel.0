From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: libipq/payload doubt
Date: Thu, 20 May 2004 09:24:58 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040520162458.75930.qmail@web13906.mail.yahoo.com>
References: <Pine.LNX.4.44.0405201659590.7143-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ulysses Almeida <munky@maluco.com.br>,
  Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405201659590.7143-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

AH yes, mentioned in my sentences, not in code :P
instead of sizeof(ip) you will want the offset...
Note that the ip protocol does not need htons()
Also, since ipHeader->tot_len represents the entire ip
datagram in case you want to do any validation on the
settings for the header size indicators.

int utilities::ip_payload_offset(unsigned char
*ip_packet)
{
unsigned int offset=0;
struct tcphdr *tcpHeader;
struct iphdr *ipHeader;

   ipHeader=(struct iphdr *)ip_packet;
  // Determine offset into packet contents.
  if (ipHeader.protocol==IPPROTO_TCP) {
      tcpHeader=(tcphdr *)(ip_packet+ipHeader->ihl*4);
      offset=ipHeader->ihl*4 + tcpHeader->doff*4;
  if (ipHeader.protocol==IPPROTO_UDP) {
      offset=ipHeader->ihl*4+8;
  } else {
      return -1;
  }
  return offset;
}



--- Henrik Nordstrom <hno@marasystems.com> wrote:
> On Thu, 20 May 2004, Scott MacKay wrote:
> 
> >   // Determine offset into packet contents.
> >   if (ip_packet[9]==6) {
> >       tcpHeader=(tcphdr *)(ip_packet+sizeof(ip));
> 
> Don't do this. There may be IP options extending the
> size of the IP
> header. Use iphdr->ihl to find the IP header size in
> the same manner as
> tcphdr->doff is used to find the size of the TCP
> header..
> 
> Regards
> Henrik
> 
> 



	
		
__________________________________
Do you Yahoo!?
Yahoo! Domains – Claim yours for only $14.70/year
http://smallbusiness.promotions.yahoo.com/offer 
