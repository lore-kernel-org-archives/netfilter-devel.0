From: Krzysztof Oledzki <olenf@ans.pl>
Subject: UNREPLIED ICMP packets & conntrack-tool
Date: Wed, 2 Nov 2005 11:04:24 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511021057010.17619@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1847497533-1130925864=:17619"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1847497533-1130925864=:17619
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

It seems that second id=3D7289 is missing:

conntrack -L:
icmp     1 28 src=3D192.168.0.33 dst=3DXXX.XXX.XXX.XXX type=3D8 code=3D0 id=
=3D7289 packets=3D4 bytes=3D336 [UNREPLIED] src=3DXXX.XXX.XXX.XXX dst=3D192=
=2E168.0.33 type=3D0 code=3D0 packets=3D0 bytes=3D0 mark=3D0 use=3D1

/proc/net/ip_conntrack:
icmp     1 28 src=3D192.168.0.33 dst=3DXXX.XXX.XXX.XXX type=3D8 code=3D0 id=
=3D7289 packets=3D4 bytes=3D336 [UNREPLIED] src=3DXXX.XXX.XXX.XXX dst=3D192=
=2E168.0.33 type=3D0 code=3D0 id=3D7289 packets=3D0 bytes=3D0 mark=3D0 use=
=3D1


Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1847497533-1130925864=:17619--
