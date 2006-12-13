From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Wed, 13 Dec 2006 09:31:05 +0100 (CET)
Message-ID: <36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <lartc-bounces@mailman.ds9a.nl>
In-Reply-To: <457E6997.1050001@trash.net>
To: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
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

Thanks for your response.

I'm using multiple gateways for internet connection and having problems
with random disconection, and I not use ROUTE usually, but I was trying t=
o
force only one gateway for one type of traffic (which the clients lost
conections and are having issues).

I know I can use -j MARK or -j CONNMARK and this mark to filter, but I'm
using marks for another purposes and I can't use it for routing.

The box is a dual xeon and the kernel has been compiled SMP enabled.

I haven't tested ROUTE yet with this kernel (2.6.19), but with 2.6.18.x I
were having a problem with -j ROUTE in -t mangle and POSTROUTING chain.

Perhaps ROUTE need a more in deepth revision?

Do I help more reporting the bug into netfilter-bugzilla?

Thanks a lot.

El Mar, 12 de Diciembre de 2006, 9:34, Patrick McHardy escribi=F3:
> ArcosCom Linux User wrote:
>> El Lun, 11 de Diciembre de 2006, 20:44, ArcosCom Linux User escribi=F3=
:
>>
>>>Hi, I'm having problems with this configuration:
>>>   iptables 1.3.7 (vanilla or repackaged for fc5)
>>>   kernel 2.6.19 (vanilla)
>>>   ROUTE 1.11 (last pom-ng)
>>>   layer7-filter 2.6 (last in sf.net)
>>>   connlimit (last pom-ng)
>>>
>>>When I try to use -j ROUTE in any chain in mangle table I have this
>>> error:
>>>
>>>[root@myhost ~]# iptables -v -t mangle -A POSTROUTING -p tcp --dport
>>> msnp
>>>-j ROUTE --gw $chat_gw
>>>ROUTE  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:1863
>>> ROUTE
>>>gw:80.32.61.1
>>>iptables: Invalid argument
>>>
>>>[root@myhost ~]# dmesg | grep "ROUTE"
>>>ipt_ROUTE: targinfosize 0 !=3D 40
>
>
> The ROUTE target needs to set the targetsize field in struct ipt_target=
.
> It probably needs other adjustments for 2.6.19 as well. I would just us=
e
> normal policy routing ..
>
>
>
