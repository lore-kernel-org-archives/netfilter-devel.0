From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Tue, 12 Dec 2006 09:33:42 +0100
Message-ID: <20061212083342.GA6863@innominate.com>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
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

On Tue, Dec 12, 2006 at 09:24:38AM +0100, ArcosCom Linux User wrote:
> Any help about this?

If you check out your compiler run you will find that there was
a warning about incompatible function arguments being used.
Read this: the in-kernel API has changed so you have to modify
the ipt_ROUTE.c file. I for myself have just removed the respective
check (as this is what seems to have been done for the other
modules) and adjusted the argument list. I'll rather not post
a patch as I am not sure whether this really is the correct
solution.

Best regards,
	Lutz

> El Lun, 11 de Diciembre de 2006, 20:44, ArcosCom Linux User escribi=F3:
> > Hi, I'm having problems with this configuration:
> >    iptables 1.3.7 (vanilla or repackaged for fc5)
> >    kernel 2.6.19 (vanilla)
> >    ROUTE 1.11 (last pom-ng)
> >    layer7-filter 2.6 (last in sf.net)
> >    connlimit (last pom-ng)
> >
> > When I try to use -j ROUTE in any chain in mangle table I have this e=
rror:
> >
> > [root@myhost ~]# iptables -v -t mangle -A POSTROUTING -p tcp --dport =
msnp
> > -j ROUTE --gw $chat_gw
> > ROUTE  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:1863 R=
OUTE
> > gw:80.32.61.1
> > iptables: Invalid argument
> >
> > [root@myhost ~]# dmesg | grep "ROUTE"
> > ipt_ROUTE: targinfosize 0 !=3D 40
> >
> > [root@myhost ~]# cat /var/log/messages | grep "ROUTE"
> > Dec 11 20:32:50 myhost kernel: ipt_ROUTE: targinfosize 0 !=3D 40
> >
> > With layer7 filter, I have a problem too, but it has no dmesg or sysl=
og
> > entry:
> >
> > [root@myhost ~]# iptables -v -t mangle -A PREROUTING -m layer7 --l7pr=
oto
> > msnmessenger
> >   0 opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  LAYER7 l7proto
> > msnmessenger
> > iptables: Invalid argument
> >
> > Does anyone help me please? I need any more recent patch?
> >
> > More info:
> >    SMP machine (dual Xeon)
> >
> > Thanks
> >
> > _______________________________________________
> > LARTC mailing list
> > LARTC@mailman.ds9a.nl
> > http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc
> >
>=20
>=20
>=20

--=20
Dr.-Ing. Lutz J=E4nicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.6392-3308
fax: +49.30.6392-3307
Albert-Einstein-Str. 14
D-12489 Berlin, Germany
www.innominate.com
