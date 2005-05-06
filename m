From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_nat_mangle_udp_packet problems
Date: Fri, 06 May 2005 18:24:24 +0200
Message-ID: <427B9A38.2040602@trash.net>
References: <1115310771.1852.11.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@arnet.com.ar>
In-Reply-To: <1115310771.1852.11.camel@www.l-chr.com.ar>
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

Christian Hentschel wrote:
> Hi, 
> 	i hope someone could answer this problem i'm experimenting. I'm writing
> a SIP/RTP conntrack/NAT helper, and i need to mangle packets multiple
> times, since there are lots of fields to be mangled.
> 	I'm using new conntrack/nat framework (>2.6.11) and the way i took to
> do it is causing me some problems.
> 	Basically, i just look for string into the packet, mangle it and call
> ip_nat_mangle_udp_packet(). The problem is when i try to search the
> nexts strings, i get the wrong offsets. 
> I saw ip_nat_mangle_udp_packet() does not do it manipulation
> immediatelly. Please could someone explain this ?.

enlarge_skb() called from ip_nat_mangle_udp_packet() might replace the
packet if it doesn't fit. You need to reload all pointers to the skb
after calling ip_nat_mangle_udp_packet().

Regards
Patrick
