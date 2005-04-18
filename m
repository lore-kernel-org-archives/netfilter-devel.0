From: Amin Azez <azez@ufomechanic.net>
Subject: Re: conntrack-tool core dumps
Date: Mon, 18 Apr 2005 16:35:14 +0100
Message-ID: <4263D3B2.1090308@ufomechanic.net>
References: <20050418173034.0372.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050418173034.0372.LARK@linux.net.cn>
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

Wang, I don't get a core dump. I am happy to compare notes on what we did.

I do note that all of my reported events are:
type: [NEW]
even current connections and closing connections.

At the moment my nfnetlink and ctnetlink kernel modules are the result
of some patches Pablo published and some patches I sent him.

In order to canonicalise my build process against more official sources
and also to check if I get core-dumps when I build the way you
described, I am taking pristine 2.6.11-6 sources and applying the latest
pom-ng's to it to get nfnetlink and ctnetlink.

[later]

This is what I did.
1) untar pristine 2.6.11-6
2) untar latest pom-ng
3) patch pom-ng with first patch from PAblo's message dated 12/4/2005
4) rename ctevent-api to conntrack-event-api
5) pom-ng apply conntrack-event-api and ctnetlink (pom-ng never asked 
about nfnetlink but it seems to have applied)
6) reboot with new kernel, rmmod ip_queue, modprobe ip_conntrack_netlink
7) get latest libctnetlink and libnfnetlink snapshots
8) compile, build and install those
9) rebuild conntrack-tool

It still works fine with no errors.

I'm not looking at Harald's packet accounting that you tipped me on, or 
I will rework what I wrote before against the pom-ng'd versions and use 
Jonas cool Patch2pom tool.

Amin

Wang Jian wrote:
> Hi,
> 
> When some packets hit the box, conntrack-tool core dumps, below is
> backtrace
> 
> [root@qos conntrack-tool]# gdb conntrack core.3023 
> ...
> Loaded symbols for extensions/libct_proto_tcp.so
> #0  0xb7f1fc2a in strcmp () from /lib/tls/libc.so.6
> (gdb) bt
> #0  0xb7f1fc2a in strcmp () from /lib/tls/libc.so.6
> #1  0x0804aaf8 in findproto (name=0x0) at src/libct.c:429
> #2  0x0804a301 in event_handler (sock=0xbffff710, nlh=0xbfffd75c, 
>     arg=0xbffff770) at src/libct.c:181
> #3  0x0804ae9c in list_conntrack_handler ()
> #4  0x0804bb4b in nfnl_listen ()
> #5  0x0804b08d in ctnl_event_conntrack ()
> #6  0x0804aa82 in event_conntrack () at src/libct.c:413
> #7  0x08049d05 in main (argc=3, argv=0xbffff904) at src/conntrack.c:458
> (gdb) up
> #1  0x0804aaf8 in findproto (name=0x0) at src/libct.c:429
> 429                     if (strcmp(cur->name, name) == 0) {
> (gdb) print cur
> $1 = (struct ctproto_handler *) 0xb7fe9b60
> (gdb) print name
> $2 = 0x0
> (gdb) print cur->name
> $3 = 0xb7fe89a7 "tcp"
> 
> 
> 
> 
