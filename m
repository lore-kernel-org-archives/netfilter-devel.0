From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter+IPsec patches
Date: Thu, 27 May 2004 02:56:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B53CCE.40704@trash.net>
References: <20040526033537.GH4402@samad.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20040526033537.GH4402@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Alexander Samad wrote:
> Patrick
> 
> whilst debugging a ipsec bug I noticed these problems
> 
> when you do a tcpdump you the decrypted packet seems to show up
>  twice it seems to be the exact same packet.

Yes, this is a consequence of passing the packets though the stack again
once we know decapsulation is finished. It will also cause statistics
to account for the packet twice.

> 
> I am running this on a debian 2.6.4 kernel with the netfilter patchs
> applied
> (up to date cvs)
> 
> 
> tcpdump output
> =========
> 13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 150:
> 202.154.115.130 > 138.130.55.80: ESP(spi=0x6e3852ef,seq=0x29)
> 13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 98: 192.168.5.1 >
> 192.168.10.1: icmp: echo request (DF)
> 13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 98: 192.168.5.1 >
> 192.168.10.1: icmp: echo request (DF)
> 
> 
> my other problem is when I ping across the ipsec tunnel  from the remote
> end to the server end I see the packets come in the interface, I see
> them in the INPUT table and in the mangle table, but it never seems to
> get back to the application

Please give some more details on the configuration, like:

Are you using NAT ?
Are you marking the packets in the mangle table ?
Are the packets forwarded when they get out of the tunnel ?

When you see the packets in the INPUT chain, does their source- and
destination address match your policy ?

Regards
Patrick

> 
> 
> 
> from ipsec auto --status
> ====
> 000 "roadwarrior.internet.nat"[4]:
> 192.168.8.0/22===138.130.55.80:4500[C=AU, ST=NSW, L=Sydney, O=A.Samad
> Pty Ltd, OU=Alfred St, CN=sydlxfw01,
> E=sydlxfw01@samad.com.au]---138.130.52.1...144.137.104.46:4500[C=AU,
> ST=NSW, L=Sydney, O=A.Samad Pty Ltd, OU=Alfred St,
> CN=asamadlx.samad.com.au, E=asamadlx@samad.com.au]===192.168.8.2/32;
> erouted; eroute owner: #30
> 
> Thanks
> Alex
