From: - = k o l i s k o = - <kolisko@penguin.cz>
Subject: h323 compilation error
Date: 18 Feb 2003 22:15:03 +0100
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <1045602903.1536.13.camel@kolisko>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	kadlec@blackhole.kfki.hu
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

i have a linux 2.4.21-pre4 patched by h323-conntrack-nat.patch and set
Makefile, Configure.help, Configure.in and when i compile kernel i get
this error message:


gcc -D__KERNEL__ -I/usr/src/linux-2.4.21-pre4/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common
-fomit-frame-pointer -pipe -mpreferred-stack-boundary=3D2 -march=3Di686 =20
-nostdinc -iwithprefix include -DKBUILD_BASENAME=3Dip_conntrack_h323  -c
-o ip_conntrack_h323.o ip_conntrack_h323.c
ip_conntrack_h323.c: In function `h245_help':
ip_conntrack_h323.c:49: union has no member named `ct_h225_info'
ip_conntrack_h323.c:51: union has no member named `exp_h225_info'
ip_conntrack_h323.c: In function `h225_help':
ip_conntrack_h323.c:166: union has no member named `ct_h225_info'
ip_conntrack_h323.c:168: union has no member named `exp_h225_info'
make[3]: *** [ip_conntrack_h323.o] Error 1
make[3]: Leaving directory
`/usr/src/linux-2.4.21-pre4/net/ipv4/netfilter'
make[2]: *** [first_rule] Error 2
make[2]: Leaving directory
`/usr/src/linux-2.4.21-pre4/net/ipv4/netfilter'
make[1]: *** [_subdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.21-pre4/net'
make: *** [_dir_net] Error 2

What is wrong?

Thank You.
kolisko


--=20

---
Michal Koles=E1r
kolisko@penguin.cz
http://kolisko.penguin.cz
+420.777.225.297


Don't send me any attachment in Micro$oft (.DOC, .PPT) format please
Read http://www.fsf.org/philosophy/no-word-attachments.html
Preferable attachments: .PDF, .HTML, .TXT
Thanx for adding this text to Your signature
