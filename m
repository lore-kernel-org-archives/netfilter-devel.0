From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Mon, 11 Dec 2006 20:44:36 +0100 (CET)
Message-ID: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: LARTC@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	l7-filter-developers@lists.sourceforge.net
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

Hi, I'm having problems with this configuration:
   iptables 1.3.7 (vanilla or repackaged for fc5)
   kernel 2.6.19 (vanilla)
   ROUTE 1.11 (last pom-ng)
   layer7-filter 2.6 (last in sf.net)
   connlimit (last pom-ng)

When I try to use -j ROUTE in any chain in mangle table I have this error=
:

[root@myhost ~]# iptables -v -t mangle -A POSTROUTING -p tcp --dport msnp
-j ROUTE --gw $chat_gw
ROUTE  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:1863 ROUTE
gw:80.32.61.1
iptables: Invalid argument

[root@myhost ~]# dmesg | grep "ROUTE"
ipt_ROUTE: targinfosize 0 !=3D 40

[root@myhost ~]# cat /var/log/messages | grep "ROUTE"
Dec 11 20:32:50 myhost kernel: ipt_ROUTE: targinfosize 0 !=3D 40

With layer7 filter, I have a problem too, but it has no dmesg or syslog
entry:

[root@myhost ~]# iptables -v -t mangle -A PREROUTING -m layer7 --l7proto
msnmessenger
  0 opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  LAYER7 l7proto msnmesseng=
er
iptables: Invalid argument

Does anyone help me please? I need any more recent patch?

More info:
   SMP machine (dual Xeon)

Thanks
