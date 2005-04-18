From: Wang Jian <lark@linux.net.cn>
Subject: Re: conntrack-tool core dumps
Date: Tue, 19 Apr 2005 01:03:02 +0800
Message-ID: <20050419000157.038C.LARK@linux.net.cn>
References: <20050418173034.0372.LARK@linux.net.cn>
	<4263D3B2.1090308@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <4263D3B2.1090308@ufomechanic.net>
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

Hi Amin Azez,

I am now very regret that I deleted all of core dumps. I get 4 core
dumps and now I can't duplicate core dump in 6 hours. I should use the
core dumps to get more information :(


On Mon, 18 Apr 2005 16:35:14 +0100, Amin Azez <azez@ufomechanic.net> wrote:

> Wang, I don't get a core dump. I am happy to compare notes on what we did.
> 
> I do note that all of my reported events are:
> type: [NEW]
> even current connections and closing connections.
> 

This is not the case in my side. For example:

type: [NEW] src=192.168.0.123 dst=64.4.21.188 sport=2580 dport=80 src=64.4.21.188 dst=192.168.0.123 sport=80 dport=2580 timeout:10 tcp 6
type: [DESTROY] src=192.168.0.123 dst=64.4.21.188 sport=2580 dport=80 src=64.4.21.188 dst=192.168.0.123 sport=80 dport=2580 timeout:10 

There is problem to create whole sessions record from events. event
messages should carry necessary information for correlation


> At the moment my nfnetlink and ctnetlink kernel modules are the result
> of some patches Pablo published and some patches I sent him.
> 
> In order to canonicalise my build process against more official sources
> and also to check if I get core-dumps when I build the way you
> described, I am taking pristine 2.6.11-6 sources and applying the latest
> pom-ng's to it to get nfnetlink and ctnetlink.
> 
> [later]
> 
> This is what I did.
> 1) untar pristine 2.6.11-6

I am using pristine 2.6.11.

> 2) untar latest pom-ng

I use pom-ng from head of trunk (r3880).

> 3) patch pom-ng with first patch from PAblo's message dated 12/4/2005
> 4) rename ctevent-api to conntrack-event-api
> 5) pom-ng apply conntrack-event-api and ctnetlink (pom-ng never asked 
> about nfnetlink but it seems to have applied)

# ./pppp conntrack-event-api nfnetlink ctnetlink

pppp is a wrapper script which defines kernel and itpables dir

> 6) reboot with new kernel, rmmod ip_queue, modprobe ip_conntrack_netlink
> 7) get latest libctnetlink and libnfnetlink snapshots

I use libnfnetlink and libctnetlink from head of trunk (r3880)

> 8) compile, build and install those
> 9) rebuild conntrack-tool

I did some trivial tweak 

diff -ur conntrack-tool/Makefile conntrack-tool.new/Makefile
--- conntrack-tool/Makefile     2005-04-13 07:47:31.000000000 +0800
+++ conntrack-tool.new/Makefile 2005-04-19 00:37:54.000000000 +0800
@@ -1,11 +1,11 @@
-LINKOPTS=-ldl -lnfnetlink -lctnetlink -rdynamic
+LINKOPTS=-ldl -lctnetlink -lnfnetlink -rdynamic
 KERNELDIR=/lib/modules/$(shell uname -r)/build/include/
-CFLAGS=-I${KERNELDIR} -Iinclude/ -g
+CFLAGS=-I${KERNELDIR} -I/home/netfilter/libnfnetlink/ -I/home/netfilter/libctnetlink/ -I/home/linux-2.6.11-w/include -Iinclude/ -g
 
 default:
        ${CC} -c ${CFLAGS} src/conntrack.c -o src/conntrack.o
        ${CC} -c ${CFLAGS} src/libct.c -o src/libct.o
-       ${CC} ${LINKOPTS} src/conntrack.o src/libct.o -o conntrack
+       ${CC} src/conntrack.o src/libct.o -o conntrack ${LINKOPTS} 
        ${MAKE} -C extensions/
 
 clean:
diff -ur conntrack-tool/src/libct.c conntrack-tool.new/src/libct.c
--- conntrack-tool/src/libct.c  2005-04-15 18:10:24.000000000 +0800
+++ conntrack-tool.new/src/libct.c      2005-04-19 00:39:42.000000000 +0800
@@ -323,7 +323,7 @@
        }
 
        /* FIXME: please unify returns values... */
-       if (ctnl_del_conntrack(&cth, tuple, t, id) < 0) {
+       if (ctnl_del_conntrack(&cth, tuple, t) < 0) {
                printf("error del conntrack\n");
                exit(0);
        }
@@ -354,7 +354,7 @@
        ctnl_register_handler(&cth, &h);
 
        /* FIXME!!!! get_conntrack_handler returns -100 */
-       if (ctnl_get_conntrack(&cth, tuple, t, id) != -100) {
+       if (ctnl_get_conntrack(&cth, tuple, t) != -100) {
                printf("error get conntrack\n");
                exit(0);
        }


> 
> It still works fine with no errors.
> 
> I'm not looking at Harald's packet accounting that you tipped me on, or 
> I will rework what I wrote before against the pom-ng'd versions and use 
> Jonas cool Patch2pom tool.
> 
> Amin
> 
> Wang Jian wrote:
> > Hi,
> > 
> > When some packets hit the box, conntrack-tool core dumps, below is
> > backtrace
> > 
> > [root@qos conntrack-tool]# gdb conntrack core.3023 
> > ...
> > Loaded symbols for extensions/libct_proto_tcp.so
> > #0  0xb7f1fc2a in strcmp () from /lib/tls/libc.so.6
> > (gdb) bt
> > #0  0xb7f1fc2a in strcmp () from /lib/tls/libc.so.6
> > #1  0x0804aaf8 in findproto (name=0x0) at src/libct.c:429
> > #2  0x0804a301 in event_handler (sock=0xbffff710, nlh=0xbfffd75c, 
> >     arg=0xbffff770) at src/libct.c:181
> > #3  0x0804ae9c in list_conntrack_handler ()
> > #4  0x0804bb4b in nfnl_listen ()
> > #5  0x0804b08d in ctnl_event_conntrack ()
> > #6  0x0804aa82 in event_conntrack () at src/libct.c:413
> > #7  0x08049d05 in main (argc=3, argv=0xbffff904) at src/conntrack.c:458
> > (gdb) up
> > #1  0x0804aaf8 in findproto (name=0x0) at src/libct.c:429
> > 429                     if (strcmp(cur->name, name) == 0) {
> > (gdb) print cur
> > $1 = (struct ctproto_handler *) 0xb7fe9b60
> > (gdb) print name
> > $2 = 0x0
> > (gdb) print cur->name
> > $3 = 0xb7fe89a7 "tcp"
> > 
> > 
> > 
> > 
> 
> 
> 



-- 
  lark
