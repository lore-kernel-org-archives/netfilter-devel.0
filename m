From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: libipq/payload doubt
Date: Thu, 20 May 2004 06:33:13 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040520133313.70860.qmail@web13905.mail.yahoo.com>
References: <20040520021119.GA2959@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>,
  Netfilter Devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040520021119.GA2959@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Not sure if this answers you entirely, but I will give
it a shot....

The payload is the actual ether packet.  The protocol
tell you the type (IP) but not the IP protocol (UDP,
TCP, etc).  The payload will consist of the protocol
(like ip) followed by the ip protocol header (for IP)
like udp/tcp, and then the data.

The very start of the payload is the contents of the
ether packet 'payload', so the start of the IP header
on a packet.  You can either cast it to a header
definition (like struct iphdr) or use the bytes. 
payload[9] is the prtocol ID (UDP. TCP, etc).
The offset to the protocol header, based on the IP
protocol is the low 4 bits of the 1st payload byte (ip
header length).  This is in full 4 byte words, so it
would be:
payload[0]&0x04 * 4.  Normally this will equate to 20
bytes (min IP length) unless there are IP options.
This will be the start of the udp/tcp/etc header
(almost to the real payload!).
UDP is always 8 bytes, tcp uses a similar formula as
ip since it supports options.  Minimally it is 20
bytes.


Examples to calculate offset to the actual payload:

int ip_payload_offset(unsigned char *ip_packet)
{
unsigned int offset=0;
struct tcphdr *tcpHeader;
struct udphdr *udpHeader;

  // Determine offset into packet contents.
  if (ip_packet[9]==6) {
      tcpHeader=(tcphdr *)(ip_packet+sizeof(ip));
      offset=sizeof(ip) + tcpHeader->doff*4;
  } else if (ip_packet[9]==17) {
      offset=sizeof(ip)+8;
  } else {
      return -1;
  }
  return offset;
}

Keep in mind this expects you already checked protocol
for it being IP and it does not insure the size of
ip_packet (for the [9] index or for insuring offset is
within the data_len range.  



--- Ulysses Almeida <munky@maluco.com.br> wrote:
>   Realy sorry, for this stupid question.. i just
> find iphdr->protocol
> that answers my first question. I don't have a clear
> idea about
> payload yet, but I'm walking on this direction.
> 
>   Best regards
> 
> On Wed, May 19, 2004 at 08:03:06PM -0400, Ulysses
> Almeida wrote:
> >   Thanks, all, I just tried with htons(), and
> every thing works fine.
> > 
> >   Now I another doubt. I alredy read ip_queue.c,
> and alredy understood,
> > that payload is skb->data.
> > 
> >   memcpy(pmsg->payload, entry->skb->data,
> data_len);
> > 
> >   But, skb->data isn't clear enough on my head. If
> I queue every packge,
> > can I know which type is it? (TCP/UDP/ICMP), just
> looking for payload?
> >   Packet data, can be analyzed on userspace, or
> maybe changed?
> > 
> >   How can i get a payload X-ray?
> > 
> >   When i tried something like printf ("%d\n",
> tcph->syn); i started to
> > recive "passer: Received message truncated: No
> such file or directory"
> > from my program. What is it means?
> > 
> >   The last question, probably I can easily find on
> google, but the
> > other ones, I can't find that easy
> > 
> >   I think that's it for today! (One day I'll be
> able to answer
> > begginers question, yes I will, I belive in that!
> ;))
> > 
> 
> -- 
>     .~.  Ulysses Almeida
>    / V \  munky@maluco.com.br
>  / (   ) \  Seja livre, use GNU/Linux! 
>    ^^-^^
> 



	
		
__________________________________
Do you Yahoo!?
Yahoo! Domains – Claim yours for only $14.70/year
http://smallbusiness.promotions.yahoo.com/offer 
