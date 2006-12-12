From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Tue, 12 Dec 2006 09:34:31 +0100
Message-ID: <457E6997.1050001@trash.net>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: lartc@mailman.ds9a.nl,
	l7-filter-developers@lists.sourceforge.net,
	netfilter-devel@lists.netfilter.org
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: linux@arcoscom.com
In-Reply-To: <57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
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

ArcosCom Linux User wrote:
> El Lun, 11 de Diciembre de 2006, 20:44, ArcosCom Linux User escribi=F3:
>=20
>>Hi, I'm having problems with this configuration:
>>   iptables 1.3.7 (vanilla or repackaged for fc5)
>>   kernel 2.6.19 (vanilla)
>>   ROUTE 1.11 (last pom-ng)
>>   layer7-filter 2.6 (last in sf.net)
>>   connlimit (last pom-ng)
>>
>>When I try to use -j ROUTE in any chain in mangle table I have this err=
or:
>>
>>[root@myhost ~]# iptables -v -t mangle -A POSTROUTING -p tcp --dport ms=
np
>>-j ROUTE --gw $chat_gw
>>ROUTE  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:1863 ROU=
TE
>>gw:80.32.61.1
>>iptables: Invalid argument
>>
>>[root@myhost ~]# dmesg | grep "ROUTE"
>>ipt_ROUTE: targinfosize 0 !=3D 40


The ROUTE target needs to set the targetsize field in struct ipt_target.
It probably needs other adjustments for 2.6.19 as well. I would just use
normal policy routing ..
