From: Wang Jian <lark@linux.net.cn>
Subject: conntrack-tool core dumps
Date: Mon, 18 Apr 2005 17:38:15 +0800
Message-ID: <20050418173034.0372.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

When some packets hit the box, conntrack-tool core dumps, below is
backtrace

[root@qos conntrack-tool]# gdb conntrack core.3023=20
=2E..
Loaded symbols for extensions/libct_proto_tcp.so
#0  0xb7f1fc2a in strcmp () from /lib/tls/libc.so.6
(gdb) bt
#0  0xb7f1fc2a in strcmp () from /lib/tls/libc.so.6
#1  0x0804aaf8 in findproto (name=3D0x0) at src/libct.c:429
#2  0x0804a301 in event_handler (sock=3D0xbffff710, nlh=3D0xbfffd75c,=20
    arg=3D0xbffff770) at src/libct.c:181
#3  0x0804ae9c in list_conntrack_handler ()
#4  0x0804bb4b in nfnl_listen ()
#5  0x0804b08d in ctnl_event_conntrack ()
#6  0x0804aa82 in event_conntrack () at src/libct.c:413
#7  0x08049d05 in main (argc=3D3, argv=3D0xbffff904) at src/conntrack.c:458
(gdb) up
#1  0x0804aaf8 in findproto (name=3D0x0) at src/libct.c:429
429                     if (strcmp(cur->name, name) =3D=3D 0) {
(gdb) print cur
$1 =3D (struct ctproto_handler *) 0xb7fe9b60
(gdb) print name
$2 =3D 0x0
(gdb) print cur->name
$3 =3D 0xb7fe89a7 "tcp"




--=20
  lark
