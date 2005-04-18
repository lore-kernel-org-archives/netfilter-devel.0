From: Wang Jian <lark@linux.net.cn>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Mon, 18 Apr 2005 15:14:41 +0800
Message-ID: <20050418141057.0363.LARK@linux.net.cn>
References: <42602331.6060706@eurodev.net>
	<20050416073637.0352.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>,
	Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050416073637.0352.LARK@linux.net.cn>
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

Hi Pablo Neira,

I have tried conntrack-tool and it works fine. Thanks for your great
work. I did some trivial changes (remove id) to use ctnetlink and
nfnetlink just added to pom-ng.

Here I list some issues I meet:

1. conntrack-tools 0.12 's Makefile doesn't work at least for gcc 3.3.4
and 3.4.x

The link command line

        ${CC} ${LINKOPTS} src/conntrack.o src/libct.o -o conntrack

should be

        ${CC} src/conntrack.o src/libct.o -o conntrack ${LINKOPTS}

and

LINKOPTS=-ldl -lnfnetlink -lctnetlink -rdynamic

should be

LINKOPTS=-ldl -lctnetlink -lnfnetlink -rdynamic

otherwise, linker will complains that symbols are undefined. It takes me
some time to figure out the cause is the order of options.

This is also true for your patches agains 2.6.11.


2. A little confusing output for connection refused case

# ./conntrack -E conntrack

type: [NEW] src=192.168.0.123 dst=192.168.0.254 sport=2515 dport=20 src=192.168.0.254 dst=192.168.0.123 sport=20 dport=2515 status:8 timeout:120 tcp 6
type: [DESTROY] src=192.168.0.123 dst=192.168.0.254 sport=2515 dport=20 src=192.168.0.254 dst=192.168.0.123 sport=20 dport=2515 status:8 timeout:120 

type: [NEW] src=192.168.0.123 dst=192.168.0.254 sport=2515 dport=20 src=192.168.0.254 dst=192.168.0.123 sport=20 dport=2515 status:10 tcp 6

Should the third event after destroying ct be emit before DESTORY?

3. There seems to be an empty or invalid entry at the end of destory
message, which leads to an extra "\n" be printed by event_handler().

4. Also, for successful connection, there is an extra '\n'.

type: [NEW] src=192.168.0.254 dst=192.168.0.27 sport=2394 dport=22 src=192.168.0.27 dst=192.168.0.254 sport=22 dport=2394 status:8 timeout:120 tcp 6
type: [NEW] src=192.168.0.254 dst=192.168.0.27 sport=2394 dport=22 src=192.168.0.27 dst=192.168.0.254 sport=22 dport=2394 status:10 timeout:60 tcp 6

type: [NEW] src=192.168.0.254 dst=192.168.0.27 sport=2394 dport=22 src=192.168.0.27 dst=192.168.0.254 sport=22 dport=2394 timeout:432000 tcp 6



On Sat, 16 Apr 2005 07:50:32 +0800, Wang Jian <lark@linux.net.cn> wrote:

> Hi Pablo Neira,
> 
> Thanks for you information :)
> 
> I will look into conntrack-tool.
> 
> BTW:
> 
> Is there any documentation about ct-event notification API /
> libnfnetlink / libctnetlink?
> 
> If there is none, I think I can help drafting it. But I need some hints
> on the big picture.
> 
> On Fri, 15 Apr 2005 22:25:21 +0200, Pablo Neira <pablo@eurodev.net> wrote:
> 
> > Wang Jian wrote:
> > > Hi Pablo Neira,
> > > 
> > > The current patches (dated 14-Apr), seems to not emit event messages,
> > > such as when new connection is established.
> > 
> > Hm it works just fine here.
> > 
> > o The ct-event notification API is ok, try this test:
> > http://people.netfilter.org/~pablo/patches/test/ct-event-test.tar.gz
> > 
> > o Netlink notification works fine as well via:
> > http://people.netfilter.org/~pablo/conntrack-tool/
> > 
> > Try:
> > # conntrack -E conntrack
> > 
> > So I don't see any problem.
> > 
> > > The only event emitter I find is in ip_conntrack_in()
> > > 
> > >         if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
> > >                 ip_conntrack_event_cache(IPCT_STATUS, *pskb);
> > > 
> > > set_reply is set to 1 only when the first reply packet seen from server
> > > end of a "connection", and !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status)
> > > is supposed to be true at the moment. So it will emit event once. But
> > > in my test, cntltest doesn't receive this event.
> > > 
> > > Did I miss something?
> > 
> > I'll update ctnltest.c soon since it's currently broken. I haven't mind 
> > about it so far.
> > 
> > --
> > Pablo
> 
> 
> 
> -- 
>   lark
> 



-- 
  lark
