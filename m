From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Tue, 12 Dec 2006 09:24:38 +0100 (CET)
Message-ID: <57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
To: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	l7-filter-developers@lists.sourceforge.net
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

Any help about this?

Thanks

El Lun, 11 de Diciembre de 2006, 20:44, ArcosCom Linux User escribió:
> Hi, I'm having problems with this configuration:
>    iptables 1.3.7 (vanilla or repackaged for fc5)
>    kernel 2.6.19 (vanilla)
>    ROUTE 1.11 (last pom-ng)
>    layer7-filter 2.6 (last in sf.net)
>    connlimit (last pom-ng)
>
> When I try to use -j ROUTE in any chain in mangle table I have this error:
>
> [root@myhost ~]# iptables -v -t mangle -A POSTROUTING -p tcp --dport msnp
> -j ROUTE --gw $chat_gw
> ROUTE  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:1863 ROUTE
> gw:80.32.61.1
> iptables: Invalid argument
>
> [root@myhost ~]# dmesg | grep "ROUTE"
> ipt_ROUTE: targinfosize 0 != 40
>
> [root@myhost ~]# cat /var/log/messages | grep "ROUTE"
> Dec 11 20:32:50 myhost kernel: ipt_ROUTE: targinfosize 0 != 40
>
> With layer7 filter, I have a problem too, but it has no dmesg or syslog
> entry:
>
> [root@myhost ~]# iptables -v -t mangle -A PREROUTING -m layer7 --l7proto
> msnmessenger
>   0 opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  LAYER7 l7proto
> msnmessenger
> iptables: Invalid argument
>
> Does anyone help me please? I need any more recent patch?
>
> More info:
>    SMP machine (dual Xeon)
>
> Thanks
>
> _______________________________________________
> LARTC mailing list
> LARTC@mailman.ds9a.nl
> http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc
>
