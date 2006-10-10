From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel oops with NAT in 2.6.16.13 kernel
Date: Tue, 10 Oct 2006 08:01:18 +0200
Message-ID: <452B372E.3020206@trash.net>
References: <00fb01c6e91d$08bf3570$4c01a8c0@elitecore26>	<452B29F2.70105@trash.net>
	<02a901c6ec2f$f5d1e730$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nishit Shah <nishit@elitecore.com>
In-Reply-To: <02a901c6ec2f$f5d1e730$4c01a8c0@elitecore26>
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

Nishit Shah wrote:
> I have performed load testing through Spirent avalanche.(Test Specification
> is Connections/Second).
> At one side of testing machine, there are 10/11 virtual clients created by
> Spirent and 4/5 virtual servers at other side.
> Testing is through HTTP 1.0 with heep alive and 1024 bytes of object size.
> I haven't loaded or unloaded any modules..
> I have loaded conntrack module with following parameters.
> modprobe conntrack hashsize=262144
> echo 1048576 > /proc/sys/net/ipv4/ip_conntrack_max
> (Testing machines contain >= 1 GB of RAM and those were plain firewall only
> machines.)
> Connection rate is around 4000 Connections/Second at the time of oops and
> around 3,00,000 connection entries at time of oops.
> 
> Also, some of my observations,
> I don't think problem is with connection rate, problem is with number of
> connection entries.
> I have tried with different machines but every time i got kernel oops at
> 3,00,000 entries in conntrack table.(tried with Pentium 4,Xeon,Xeon duel
> etc..)

With many conntrack entries NAT may take considerable time to find a
free tuple (up to ~64000 quite expensive hash lookups). For optimal
performance, the hash should be twice as large as the maximum number
of entries. I assume the machine doesn't freeze completely but
just reports a softlockup? Are you running anything touching conntrack
/proc-files during this test?
