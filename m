From: "Preston A. Elder" <prez@srealm.net.au>
Subject: iptables/conntrack in enterprise environment.
Date: Thu, 29 May 2003 01:13:47 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305290113.58552.prez@srealm.net.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
Content-Description: clearsigned data
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I am in an enterprise environment and I'm having some problems with conntra=
ck=20
specifically.

We have a system that acts as a router, however any new inbound connection =
for=20
any machine behind this router is re-directed to a specific port on the loc=
al=20
machine, where an application responds as if it were the system behind the=
=20
router.  These systems experience some very high volumes of traffic=20
(sustaining over 30mbit of traffic).  Heres a breakdown of TCP socket=20
connections by status at one particular point in time:
ESTABLISHED : 1363
LAST_ACK    : 27
TIME_WAIT   : 616
=46IN_WAIT2   : 8
=46IN_WAIT1   : 140
SYN_RECV    : 6188
CLOSE_WAIT  : 365
LISTEN      : 3
CLOSING     : 5

We have multiple systems performing this task (essentially for load balanci=
ng=20
and to remove a single point of faulure).  The systems are dual 1ghz pentiu=
m=20
3's, with 1-2gb of ram, so they're not shy systems.  They're running 2.4.20=
=20
kernels (mostly vanilla) with iptables 1.2.7a.

Here are some system limits I am tweaking (ie. the commands to do the=20
tweaking):
echo 1 >/proc/sys/net/ip_forward
echo 524280 >/proc/sys/fs/file-max
echo 524280 >/proc/sys/net/ipv4/ip_conntrack_max
echo 65535 >/proc/sys/net/ipv4/ip_queue_maxlen
echo 65535 >/proc/sys/net/ipv4/tcp_max_syn_backlog
#     NONE    EST     SYN_S   SYN_R   FIN_W   TIME_W  CLOSE   CLOSE_W LAST_=
A =20
LISTEN
echo "1800    21600   120     60      30      30      10      30      30   =
  =20
120     " > /proc/sys/net/ipv4/ip_conntrack_tcp_timeouts
ulimit -H -n 524280
ulimit -S -n 524280
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS=20
=2D --clamp-mss-to-pmt


Because every new connection to one of the systems 'behind' these systems n=
eed=20
to be re-directed to a local port, which is achieved with the command:
/sbin/iptables -t nat -A PREROUTING -j DNAT -i eth0 -p tcp -d <ip-range>=20
=2D --destination-port 1024:65535 --to-destination <local_ip>:<local_port>

Every inbound connection incurs an entry in the connection tracking table. =
 It=20
seems, however, that we may be overloading the conntrack system.  I can=20
telnet to a different port listening on a secondary (internal) interface (b=
ut=20
the same application), that bypasses the above rule, and get an immediate=20
connection, however establishing a connection 'to' a server behind this=20
router can take a number of seconds, and sometimes may never establish. =20
Whats more connecting directly to the port everything else is being=20
re-directed to via. the 'public' interface itself can take some time (thoug=
h=20
not as long as connecting 'to' a system behind this box).

The conntrack table itself very quickly grows - but it does not clean itsel=
f=20
up when the connection itself dissapears, instead it waits for some=20
pre-determined timeout value, which means even though, as shown above, the=
=20
number of connections in-progress (one way or another) is about 8000=20
connections, the conntrack table is absolutely huge (hundreds of thousands =
of=20
entries), and as time goes on, the larger it gets.  To try to combat this,=
=20
I've reduced the biggest timer (how long an established connection stays in=
=20
conntrack) from 5 days to 6 hours (all the connections we have are, and=20
should be, short lived, so that is plenty of time).  This helps a bit,=20
however I'm still at a loss to try to understand why conntrack does not cle=
an=20
itself up when the connection gets closed.

Of course, seeing how big the conntrack table is, itself, impacts the syste=
m=20
dramatically.  The 'wc -l /proc/net/ip_conntrack' command takes a long time=
=20
to run, and brings the 'active' processing to its knees while doing this.=20
=2D From all appearances, it appears conntrack is hamstringing us.  It appe=
ars it=20
is not able to properly handle large-traffic systems, especially where=20
essentially every connection going through the system is nat'd.

I'd appreciate ANY help or thoughts on how to remedy this issue, as I have=
=20
said, this is in use in an enterprise environment (which of course, means I=
=20
cannot divulge the purpose of the application I mentioned earlier (however=
=20
all you really need to know is the application does not really know (or car=
e)=20
weather the connection to it is nat'd, and just uses it as a standard socke=
t=20
connection), however I can give details on the system/kernel/netfilter=20
configuration as necessary, just let me know what further information you=20
require).

I thank you in advance, and apologise for mailing all 3 lists, however I=20
figured someone on ONE of these lists would have an idea or a suggestion.

=2D --=20
PreZ
Systems Administrator
Shadow Realm

PGP FingerPrint: B3 0C F3 32 DE 5A 7D 90  26 F6 FA 38 CC 0A 2D D8
=46inger prez@srealm.net.au for full PGP public key.

Shadow Realm, a hobbyist ISP supplying real internet services.
http://www.srealm.net.au
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+1ZcVKFp14D8AGEQRAh4jAJ9mhilrpVsDvakS03re/HsT1jcXcwCcDqFT
nHqa0y2UPb9s5JgRsGIhP8o=3D
=3DbmA5
=2D----END PGP SIGNATURE-----
