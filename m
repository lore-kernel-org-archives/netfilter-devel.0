From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch 1/2] libnfnetlink, iface conversion to string
Date: Fri, 19 Jan 2007 18:38:42 +0100
Message-ID: <45B10222.1040806@netfilter.org>
References: <1167257854.31765.21.camel@localhost>	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>	<20070107142607.GC13543@prithivi.gnumonks.org>	<1168296086.12298.6.camel@localhost>	<20070109115120.GX7655@prithivi.gnumonks.org>	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost> <45B0E24A.7040906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <45B0E24A.7040906@trash.net>
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

Patrick McHardy wrote:
> Eric Leblond wrote:
>>  /* rtnl_receive - receive netlink packets from rtnetlink socket */
>> -int rtnl_receive()
>> +int rtnl_receive(int rtnl_fd)
> 
> header file needs to be fixed as well. Is the global rtnl_fd still
> needed?

Indeed. Eric, all this global stuff below must dissapear at all, from
rtnl.c:

static int rtnl_fd;
static int rtnl_seq = 0;
static int rtnl_dump;
static struct sockaddr_nl rtnl_local;

>From iftable.c:

static struct ifindex_map *ifindex_map[16];

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
