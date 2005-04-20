From: Pablo Neira <pablo@eurodev.net>
Subject: Re: nfnetlink/ctnetlink from pom-ng r3884
Date: Thu, 21 Apr 2005 00:44:10 +0200
Message-ID: <4266DB3A.8060106@eurodev.net>
References: <20050419212858.039E.LARK@linux.net.cn>
	<42665BF9.9090707@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42665BF9.9090707@ufomechanic.net>
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

Amin Azez wrote:
> I'm using now kernel 2.6.11.7 with nfnetlink, ctnetlink, 
> conntrack-event-api from patch-o-matic-ng svn (3884)
> 
> I'm using conntrack (3880) and libctnetlink (3877) and libnfnetlink 
> (3876) from svn.

Plus the three patches that I posted recently that fix:

a) core dump when a packet of a not know protocol is received.
b) core dump when you receive a destroy message.
c) fail if ip_queue is loaded.

Make sure that you install the libraries correctly and you aren't using 
the old ones, this is *very* important.

> I fixed conntrack to remove the "id" parameter, I also have
> CONFIG_IP_NF_CT_ACCT=y
> 
> Yet conntrack -E conntrack shows for every packet a new connection
> type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
> type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
> type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
> type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
> type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
> type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...

I'm not able to reproduce such behaviour. It works just fine here. Make 
sure that you are really using the lastest version. In such case, send 
me in private a tcpdump trace and the full list of event displayed.

> I'm also still getting some kind of "alignment" problems in 
> ip_conntrack_netlink.c such that original-bytes is 0 and reply-packets 
> seems to have the value for originating bytes.
> 
> printk("OP=%ld OB=%ld RP=%ld RB=%ld\n",
> ct->counters[IP_CT_DIR_ORIGINAL].packets,
> ct->counters[IP_CT_DIR_ORIGINAL].bytes,
> ct->counters[IP_CT_DIR_REPLY].packets,
> ct->counters[IP_CT_DIR_REPLY].bytes);
> 
> OP=1 OB=0 RP=60 RB=0
> OP=1 OB=0 RP=60 RB=0
> OP=2 OB=0 RP=112 RB=0
> OP=2 OB=0 RP=112 RB=0
> OP=3 OB=0 RP=164 RB=0
> OP=4 OB=0 RP=238 RB=0
> OP=4 OB=0 RP=238 RB=0
> OP=5 OB=0 RP=930 RB=0
> OP=5 OB=0 RP=930 RB=0
> OP=5 OB=0 RP=930 RB=0
> OP=6 OB=0 RP=1006 RB=0
> OP=6 OB=0 RP=1006 RB=0
> 
> I even put my debug in ctnetlink_conntrack_event() and it prints these 
> bogus values, and yet I can't see how this canbe the case unless the 
> kernel is walking all over the ip_conntrack struct, but then the box 
> wouldn't be this stable.

They aren't bogus, actually you see snapshots of the counters value in 
every event message.

See that we don't send a netlink message to user space every time a 
packet is received, instead we do when the state of a conntrack changes. 
So this is not a bug, it's a feature. As soon as I get some spare time 
I'll write the proper documentation and a manpage. Alternatively I'll 
appreciate if you could start writing it.

Then, to see the current value of counters use: conntrack -L conntrack

> All I can think of is to
> 1) do binary dump of ip_conntrack

if you're planning cat'ing from /proc/net/ip_conntrack, you must know 
that it harm system performance. You've been warned.

--
Pablo
