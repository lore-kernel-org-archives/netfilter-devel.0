From: Wang Jian <lark@linux.net.cn>
Subject: nfnetlink/ctnetlink from pom-ng r3884
Date: Tue, 19 Apr 2005 21:37:19 +0800
Message-ID: <20050419212858.039E.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
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

I now use conntrack/ + libctnetlink/ + libnfnetlink/ + nfnetlink/ +
ctnetlink/ + conntrack-event-api/, all are from r3884. I also enable
CT_ACCT.

First issue is this kind of duplicate in event message

type: [NEW] src=3D192.168.0.27 dst=3D192.168.0.254 sport=3D22 dport=3D2846 =
src=3D192.168.0.254 dst=3D192.168.0.27 sport=3D2846 dport=3D22 status:8 tim=
eout:432000 tcp 6 orig_packets=3D1 orig_bytes=3D0, reply_packets=3D268 repl=
y_bytes=3D0=20
type: [UPDATE] src=3D192.168.0.27 dst=3D192.168.0.254 sport=3D22 dport=3D28=
46 src=3D192.168.0.254 dst=3D192.168.0.27 sport=3D2846 dport=3D22 status:10=
 timeout:432000 orig_packets=3D1 orig_bytes=3D0, reply_packets=3D268 reply_=
bytes=3D0=20
orig_packets=3D1 orig_bytes=3D0, reply_packets=3D268 reply_bytes=3D0=20

See the second event message. account information is printed twice, that
means the netlink message has duplicated account information.


And

# ./conntrack -E conntrack
=2E..
type: [UPDATE] src=3D192.168.0.254 dst=3D192.168.0.27 sport=3D4347 dport=3D=
22 src=3D192.168.0.27 dst=3D192.168.0.254 sport=3D22 dport=3D4347 timeout:1=
20 tcp 6 orig_packets=3D5 orig_bytes=3D0, reply_packets=3D270 reply_bytes=
=3D0=20
type: [DESTROY] src=3D192.168.0.254 dst=3D192.168.0.27 sport=3D4347 dport=
=3D22 src=3D192.168.0.27 dst=3D192.168.0.254 sport=3D22 dport=3D4347 orig_p=
ackets=3D5 orig_bytes=3D0, reply_packets=3D270 reply_bytes=3D0=20
Segmentation fault (core dumped)

core dumps again. This time the backtrace is

[root@qos conntrack]# gdb conntrack core.31335=20
Loaded symbols for extensions/libct_proto_tcp.so
#0  0x0804a258 in event_handler (sock=3D0xbffff700, nlh=3D0xbfffd760,=20
    arg=3D0xbffff760) at src/libct.c:186
186                     while (NFA_OK(attr, attrlen)) {
(gdb) bt
#0  0x0804a258 in event_handler (sock=3D0xbffff700, nlh=3D0xbfffd760,=20
    arg=3D0xbffff760) at src/libct.c:186
#1  0x0804b03c in list_conntrack_handler ()
#2  0x0804bceb in nfnl_listen ()
#3  0x0804b22d in ctnl_event_conntrack ()
#4  0x0804ac02 in event_conntrack () at src/libct.c:451
#5  0x08049d51 in main (argc=3D3, argv=3D0xbffff8f4) at src/conntrack.c:473
(gdb) print attr
$1 =3D (struct nfattr *) 0xc00063c4
(gdb) print attrlen
$2 =3D 1525387413

Pablo, if you need more information, just tell me.


--=20
  lark
