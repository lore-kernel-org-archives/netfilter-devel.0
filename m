From: "HouCheng Lee" <thisrobert@mail2000.com.tw>
Subject: ICMP packets lost with an interval of 30 packets
Date: Sun, 14 Sep 2003 00:00:36 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1063468836.67875.thisrobert@mail2000.com.tw>
Reply-To: thisrobert@mail2000.com.tw
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,everyone:

I=20have=20ported=20the=202.4.18=20kernel=20to=20a=20board=20of=20MIPS=20arc=
h.
When=20I=20"make=20menuconfig",=20just=20turn=20on=20connection=20tracking
option,
and=20let=20the=20MIPS=20board=20run,=20
I=20got=20a=20strange=20icmp=20echo=20and=20reply=20pattern.

I=20config=20my=20eth0=20of=20MIPS=20board=20"192.168.1.254",
and=20ping=20it=20from=20my=20computer=20with=20IP,"192.168.1.100".
I=20got=20the=20following=20messages:
------------------------------------------------------------
PING=20192.168.1.254=20(192.168.1.254)=2056(84)=20bytes=20of=20data.
64=20bytes=20from=20192.168.1.254:=20icmp_seq=3D1=20ttl=3D255=20time=3D4.80=20=
ms
64=20bytes=20from=20192.168.1.254:=20icmp_seq=3D31=20ttl=3D255=20time=3D1.62=
=20ms
64=20bytes=20from=20192.168.1.254:=20icmp_seq=3D61=20ttl=3D255=20time=3D1.94=
=20ms
............................................
-------------------------------------------------------------
And=20when=20I=20change=20the=20"ICMP_TIMEOUT"=20variable=20in
"ip_conntrack_proto_icmp.c"=20from=20(30*Hz)=20to=20(20*Hz),
the=20echo=20and=20reply=20looks=20like=20following:
------------------------------------------------------------
PING=20192.168.1.254=20(192.168.1.254)=2056(84)=20bytes=20of=20data.
64=20bytes=20from=20192.168.1.254:=20icmp_seq=3D1=20ttl=3D255=20time=3D4.80=20=
ms
64=20bytes=20from=20192.168.1.254:=20icmp_seq=3D21=20ttl=3D255=20time=3D1.62=
=20ms
64=20bytes=20from=20192.168.1.254:=20icmp_seq=3D41=20ttl=3D255=20time=3D1.94=
=20ms
............................................
-------------------------------------------------------------=20

I=20had=20done=20the=20same=20thing=20on=20x86=20arch=20and=20everything=20w=
as=20ok.
I=20do=20not=20know=20if=20there=20are=20some=20arch=20dependent=20code=20in=

netfilter,
or=20I=20have=20missed=20some=20relevant=20modules=20or=20there=20are=20bugs=
=20in
the=20hardware.
Please=20give=20me=20some=20suggestion.=20
Thanks.
