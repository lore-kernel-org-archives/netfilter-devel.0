From: Krzysztof Oledzki <ole@ans.pl>
Subject: Wrong MAC with vlans in LOG
Date: Mon, 6 Aug 2007 13:53:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708061331010.23493@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1730061075-1186401234=:23493"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

---187430788-1730061075-1186401234=:23493
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Just discovered that -j LOG produces wrong MAC=3D(...) with non=20
hardware-accelerated vlans:

IN=3Dvlan6 OUT=3D MAC=3D00:0e:0c:a1:ba:ce:00:01:42:2f:3a:60:08:00 SRC=3D38.=
102.233.175 DST=3DXXX.XXX.XXX.XXX LEN=3D225 TOS=3D0x00 PREC=3D0x00 TTL=3D46=
 ID=3D0 DF PROTO=3DUDP SPT=3D4679 DPT=3D23020 LEN=3D205

Please notice that mac address is two bytes longer than it should be and=20
the additional 08:00 is an ethertype value: 0x0800 - IPv4.

Any ideas?

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1730061075-1186401234=:23493--
