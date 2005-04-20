From: Amin Azez <azez@ufomechanic.net>
Subject: Re: nfnetlink/ctnetlink from pom-ng r3884
Date: Wed, 20 Apr 2005 14:41:13 +0100
Message-ID: <42665BF9.9090707@ufomechanic.net>
References: <20050419212858.039E.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050419212858.039E.LARK@linux.net.cn>
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

Wang Jian wrote:
> Hi,
> 
> I now use conntrack/ + libctnetlink/ + libnfnetlink/ + nfnetlink/ +
> ctnetlink/ + conntrack-event-api/, all are from r3884. I also enable
> CT_ACCT.

I'm using now kernel 2.6.11.7 with nfnetlink, ctnetlink, 
conntrack-event-api from patch-o-matic-ng svn (3884)

I'm using conntrack (3880) and libctnetlink (3877) and libnfnetlink 
(3876) from svn.

I fixed conntrack to remove the "id" parameter, I also have
CONFIG_IP_NF_CT_ACCT=y

Yet conntrack -E conntrack shows for every packet a new connection
type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...
type: [NEW] src=192.168.0.204 dst=192.168.0.131 sport=41605 ...

I'm also still getting some kind of "alignment" problems in 
ip_conntrack_netlink.c such that original-bytes is 0 and reply-packets 
seems to have the value for originating bytes.

printk("OP=%ld OB=%ld RP=%ld RB=%ld\n",
ct->counters[IP_CT_DIR_ORIGINAL].packets,
ct->counters[IP_CT_DIR_ORIGINAL].bytes,
ct->counters[IP_CT_DIR_REPLY].packets,
ct->counters[IP_CT_DIR_REPLY].bytes);

OP=1 OB=0 RP=60 RB=0
OP=1 OB=0 RP=60 RB=0
OP=2 OB=0 RP=112 RB=0
OP=2 OB=0 RP=112 RB=0
OP=3 OB=0 RP=164 RB=0
OP=4 OB=0 RP=238 RB=0
OP=4 OB=0 RP=238 RB=0
OP=5 OB=0 RP=930 RB=0
OP=5 OB=0 RP=930 RB=0
OP=5 OB=0 RP=930 RB=0
OP=6 OB=0 RP=1006 RB=0
OP=6 OB=0 RP=1006 RB=0

I even put my debug in ctnetlink_conntrack_event() and it prints these 
bogus values, and yet I can't see how this canbe the case unless the 
kernel is walking all over the ip_conntrack struct, but then the box 
wouldn't be this stable.

All I can think of is to
1) do binary dump of ip_conntrack
2) back down the kernel to where the ct->counters are incremented until 
they start to make sense.

Amin
