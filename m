From: Michal Pokrywka <wolfmoon@o2.pl>
Subject: Bug#631945: HFSC warning issue
Date: Fri, 22 Jul 2011 11:58:54 +0200
Message-ID: <40cb21d3.13a4e2d8.4e2949de.1e1fc@o2.pl>
Reply-To: Michal Pokrywka <wolfmoon@o2.pl>, 631945@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: 00bormoj@gmail.com,
	soltys@ziu.info,
	kaber@trash.net,
	netfilter-devel@vger.kernel.org,
	fdelawarde@wirelessmundi.com
To: 631945@bugs.debian.org
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.631945.B631945.131132877621134@bugs.debian.org>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

After=20bisecting=202.6.39.1=20it=20turned=20out=20that=20the=20bug=20is=20=
caused=20independently=20by=20two=20patches:

commit=09b262a5da755cc6ed0cb4fba230cd9bf4037e1096
sch=5Fsfq:=20fix=20peek()=20implementation

and

commit=099df49f2bfe862573911a080c75a6d81113c5c81d
sch=5Fsfq:=20avoid=20giving=20spurious=20NET=5FXMIT=5FCN=20signals

Reverting=20these=20patches=20makes=20HFSC=20work=20again.

From:=2000bormoj@gmail.com
>=20I=20had=20the=20same=20problem=20when=20I=20upgraded=20to=202.6.38=20=
vanilla=20(and
>=20currently=20at=202.6.39.1),=20but=20I=20can't=20remember=20what=20the=
=20last=20successful
>=20version=20was=20(probably=20greater=20than=202.6.32).=20My=20syslog=20=
was=20full=20of=20the
>=20WARN=5FON=20trace=20from=20sch=5Fhfsc.c:1427.

Did=20you=20tested=202.6.38=20or=202.6.38.8?=20Because=20mentioned=20patc=
hes=20was=20included=20in=202.6.38.8.
