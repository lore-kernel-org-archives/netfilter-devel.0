From: Willy TARREAU <willy@w.ods.org>
Subject: Re: DNAT dosen't work
Date: Sat, 11 Oct 2003 15:34:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031011133425.GA987@pcw.home.local>
References: <A59F9B5C2A83424F9A8679E1BAB3E56610DCAA@exchange.zoodomain.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Slav Rilov <Slav.Rilov@Zoo.org>
Content-Disposition: inline
In-Reply-To: <A59F9B5C2A83424F9A8679E1BAB3E56610DCAA@exchange.zoodomain.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello !

On Fri, Oct 10, 2003 at 04:06:17PM -0700, Slav Rilov wrote:
> iptables -t nat -A PREROUTING -i eth1 -j DNAT --to-destination 10.10.1.1
> iptables -A INPUT -i eth0 -j ACCEPT
> iptables -A INPUT -i eth1 -j ACCEPT
> 
> I have log that tracks pakets and I see that packet arrives, then it destination addresses changes to 10.10.1.1 and hits eth1 instead of eth0 and stops, never gets to eth0

You are confusing addresses and interfaces. Addresses are *locally* assigned to
your system, and visible from any interface. What you have done here means
that any packed entering through interface eth1 will have their destination
address set to 10.10.1.1. Since this address is assigned to your system, the
packet will be delivered locally (eg: if you ping any address from a host on
this interface, it will reply). But there's no reason for it to change
statistics for packets coming from eth0, nor to make netfilter think it
suddenly comes from eth0. However, if you *really* want the system to believe
it comes from eth0, use the ROUTE target with the --iif flag. Although I'm not
sure that netstat will be fooled by this trick, it should be enough to match
"eth1" when checking the interface name with "-i".

Cheers,
Willy
