From: Jay Schulist <jschlst@linux-sna.org>
Subject: [PATCH] User defined udp and tcp conntrack state timeouts
Date: Wed, 18 Sep 2002 02:14:16 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0209180137170.10390-101000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-817199042-1032340456=:10390"
Cc: netfilter-devel@lists.netfilter.org,
	Jay Schulist <jschlst@linux-sna.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-817199042-1032340456=:10390
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello Harald,
Here is a patch which allows the user to set the connection tracking
timeout values on a per state basis via sysctl.

Kernel patch is against a clean linux-2.4.19

The sysctl files and their format is described below:

The timeout values are based on connection tracking states and are in
linux hertz (HZ).
=A0
Examples of hertz to time conversion.
1 second =3D 100 HZ
1 minute =3D 6000 HZ
=A0
cat /proc/sys/net/ipv4/ip_conntrack_tcp_timeouts
30000 60000 12000 6000 12000 12000 1000 6000 3000 12000
=A0
NONE =3D 30000 (5 minutes)
ESTABLISHED =3D 60000 (10 minutes)
SYN_SENT =3D 12000 (2 minutes)
SYN_RECV =3D=A0 6000 (60 seconds)
FIN_WAIT =3D 12000 (2 minutes)
TIME_WAIT =3D 12000 (2 minutes)
CLOSE =3D 1000 (10 seconds)
CLOSE_WAIT =3D 6000 (60 seconds)
LAST_ACK =3D 3000 (30 seconds)
LISTEN =3D 12000 (2 minutes)
=A0
To change the settings for this file example=A0root level syntax would be:
sysctl -w net.ipv4.ip_conntrack_tcp_timeouts=3D"30000 60000 12000 6000 1200=
0
12000 1000 6000 3000 12000"
=A0
cat /proc/sys/net/ipv4/ip_conntrack_udp_timeouts
6000 18000
=A0
UNREPLIED =3D 6000 (60 seconds)
ASSURED =3D 18000 (3 minutes)
=A0
sysctl -w net.ipv4.ip_conntrack_udp_timeouts=3D"6000 18000"
=A0
When any values are changed in these files they only have immediate effect
on new flows, old flows will use the old value until the flow has been
refreshed.

Thanks,
jay-s.

---1463811839-817199042-1032340456=:10390
Content-Type: APPLICATION/octet-stream; name="linux-2.4.19-ct-timeouts-2002091813.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209180214160.10390@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="linux-2.4.19-ct-timeouts-2002091813.diff.gz"

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
---1463811839-817199042-1032340456=:10390--
