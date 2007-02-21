From: Harvey Muller <hlmuller@yahoo.com>
Subject: [RFC][PATCH][IPTABLES]: suppress the error of modprobe
Date: Wed, 21 Feb 2007 08:45:16 -0800 (PST)
Message-ID: <465018.92293.qm@web53609.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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

Yasuyuki,=0A=0AI was unable to patch using the text you provided in the pos=
t, as it kept complaining about malformed text.=0A=0AI did however make the=
 corrections by hand using the iptables 1.3.7 release, and created a patch.=
  What I=0Anoticed is that all of the line numbers match in your post match=
, except for those in ip6tables.c.  So you=0Amay have made changes to a ver=
sion different than that noted above.=0A=0AThe patch applies successfully, =
but the following error message is emitted during make:=0A=0A=3D=3D=3D Erro=
r Message Starts =3D=3D=3D=0Aip6tables.c:1749: error: conflicting types for=
 'ip6tables_insmod'=0Ainclude/ip6tables.h:174: error: previous declaration =
of 'ip6tables_insmod' was here=0Amake: *** [ip6tables.o] Error 1=0Arm libip=
tc/libip6tc.o libiptc/libip4tc.o=0A=3D=3D=3D Error Message Ends =3D=3D=3D=
=0A=0AI hope this is helpful and best regards,=0A=0AHarvey=0A=0A
