From: stephan.dreyer@t-online.de (Stephan Dreyer)
Subject: Creating icmp packet
Date: Wed, 29 Sep 2004 17:17:03 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1CCgCT-1KnN0C0@fwd04.sul.t-online.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi
I'm using libipq to get some tcp packets and i want to send back a port
unreachable msg if ip matches some list
So far everything works fine except creating the icmp packet
Perhaps any1 can give me a hint what i made wrong?

Here my code to generate packet:

ip->version = 4;                        
ip->ihl = 5;                            
ip->id = htonl(random());               
ip->saddr = iph->daddr;
ip->daddr = iph->saddr; 
ip->ttl = 123;                          
ip->protocol = IPPROTO_ICMP;            
ip->tot_len = icmppacketsize;               
ip->check = 0;                          
				
				  
icmp->type = 3;
icmp->code = 3;
icmp->checksum = 0;
icmp->un.echo.id = m->packet_id;
icmp->checksum = in_cksum((u_short *) icmp,sizeof(icmp));
					
struct sockaddr_in icmpaddr;
	
icmpaddr.sin_family = AF_INET;
icmpaddr.sin_port = htons(111);
icmpaddr.sin_addr.s_addr = ip->saddr;
					
					
if( (sendto(rawsock,icmppacket,icmppacketsize,0,(struct
sockaddr*)&icmpaddr,sizeof(struct sockaddr_in))) == -1 )
{
 cout << "error sending icmp packet\n";
}

Send alway fails

Cheers,
Stephan
