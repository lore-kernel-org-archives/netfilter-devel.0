From: =?UTF-8?Q?=C5=81ukasz_Stosik?= <litestep@o2.pl>
Subject: Sharing information for many rules using same module
Date: Tue, 21 Aug 2007 16:54:33 +0200
Message-ID: <6ed0182d.25662f4f.46cafca9.d1786@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

Hi.
I=20am=20working=20on=20simple=20netfilter=20match=20extension.=20It=20ta=
kes=20packet,=20analyzes=20it,=20and=20puts=20all=20info=20in=20structure=
.=20Then=20it=20looks=20at=20fields=20in=20matchinfo=20and=20decides=20if=
=20there=20is=20a=20match=20or=20not.=20
The=20problem=20is=20there=20will=20be=20probably=20many=20rules,=20and=20=
each=20time=20module=20will=20repeat=20the=20first=20part=20of=20process-=
=20where=20it=20would=20be=20enought=20to=20use=20same=20structure=20as=20=
in=20first=20rule.=20Is=20there=20any=20way=20to=20share=20info=20between=
=20rules?=20
I=20would=20also=20like=20to=20know=20if=20netfilter=20is=20processing=20=
packetss=20in=20pararell=20-=20or=20maybe=20i=20can=20be=20sure=20that=20=
until=20packet=20gets=20dropped=20or=20reaches=20NIC=20driver,=20netfilte=
r=20wont=20start=20to=20process=20another=20one=20-=20that=20would=20solv=
e=20my=20problem=20as=20i=20could=20simply=20keep=20that=20info=20inside=20=
matching=20module.
And=20BTW=20something=20offtopic=20-=20what=20is=20(=20is=20there=20any)=20=
a=20good=20way=20to=20access=20userspace=20memory=20(=20for=20example=20s=
ome=20process=20gets=20information=20from=20databases,=20and=20i=20need=20=
that=20data=20inside=20kernel=20)=20from=20kernel=20module=20?
