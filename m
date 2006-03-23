From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack and IKE confused on 2.6.16
Date: Thu, 23 Mar 2006 19:22:57 +0100
Message-ID: <4422E781.6030401@trash.net>
References: <BAY103-F8424E12312A9CDFE2D9BCB2DE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F8424E12312A9CDFE2D9BCB2DE0@phx.gbl>
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

Marco Berizzi wrote:
> 1) IKE's notebook daemon send a packet to pub-ip-fi:
> src=172.16.1.227 sport=500 dst=pub-ip-fi dport=500
> 2) our firewall, lnx2.6.16 (which is also the ipsec
> endpoint for the "GOOD" tunnel) snat the IKE packet
> from the notebook with pub-ip-ve address (which is also
> the same ipsec endpoint address for the "GOOD" tunnel):
> src=pub-ip-ve sport=500 dst=pub-ip-fi dport=500
> 3) lnx2.6.16 put this entry in proc/net/ip_conntrack:
> udp      17 169 src=172.16.1.227 dst=pub-ip-fi sport=500
> dport=500 packets=51 bytes=9264 src=pub-ip-fi
> dst=pub-ip-ve sport=500 dport=500  packets=77 bytes=29760
> [ASSURED] mark=0 use=1

This is the point where the error must have occured. NAT shouldn't
NAT to port numbers that are already used, which means your first
IKE connection timed out from a conntrack POV. You can use IKE
keepalives to prevent this from happending.
