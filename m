From: Wang Jian <lark@linux.net.cn>
Subject: Re: conntrack-tool core dumps
Date: Tue, 19 Apr 2005 20:29:08 +0800
Message-ID: <20050419202007.0398.LARK@linux.net.cn>
References: <20050418173034.0372.LARK@linux.net.cn>
	<4264E119.5010506@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4264E119.5010506@eurodev.net>
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

The patch looks good. thanks.

BTW, I have tried pom-ng (r3884) conntrack-event-api/, nfnetlink/,
ctnetlink/ and conntrack/, . It works fine.

But conntrack/ + old ctevent-api patch + nfnetlink/ + ctnetlink/ will
receives strange event like

type: [NEW] src=192.168.0.254 dst=192.168.0.123 sport=2937 dport=22 src=192.168.0.123 dst=192.168.0.254 sport=22 dport=2937 status:392 timeout:120 tcp 6 
type: [DESTROY] src=192.168.0.254 dst=192.168.0.123 sport=2937 dport=22 src=192.168.0.123 dst=192.168.0.254 sport=22 dport=2937 status:392 timeout:120 

type: [UPDATE] src=192.168.0.254 dst=192.168.0.123 sport=2937 dport=22 src=192.168.0.123 dst=192.168.0.254 sport=22 dport=2937 status:394 tcp 6 

The strange place is value of status.

So anyone who wants to try should sync to the head now.

On Tue, 19 Apr 2005 12:44:41 +0200, Pablo Neira <pablo@eurodev.net> wrote:

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
> 
> The patch attached must fix your problem. I'll commit to SVN asap.
> 
> --
> Pablo



-- 
  lark
