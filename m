From: Robby <inet6@mail.be>
Subject: Re: compile error ip6t_REJECT.c and 2.4.27-rc5
Date: Sun, 8 Aug 2004 03:46:26 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <25214851.1091929586156.JavaMail.Administrator@pumbaa>
References: <200408072305.IAA04601@toshiba.co.jp>
Reply-To: Robby <inet6@mail.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, laforge@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200408072305.IAA04601@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I also have an error with ipt_ULOG.c:

gcc -D__KERNEL__ -I/usr/src/linux-2.4.27-rc5/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=i586 -DMODULE -DMODVERSIONS -include /usr/src/linux-2.4.27-rc5/include/linux/modversions.h  -nostdinc -iwithprefix include -DKBUILD_BASENAME=ipt_ULOG  -c -o ipt_ULOG.o ipt_ULOG.c
ipt_ULOG.c: In function `ip_ulog_fn':
ipt_ULOG.c:379: `qlen' undeclared (first use in this function)
ipt_ULOG.c:379: (Each undeclared identifier is reported only once
ipt_ULOG.c:379: for each function it appears in.)
make[2]: *** [ipt_ULOG.o] Error 1
make[2]: Leaving directory `/usr/src/linux-2.4.27-rc5/net/ipv4/netfilter'
make[1]: *** [_modsubdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.27-rc5/net'
make: *** [_mod_net] Error 2
[root@core1-fe0-gw1 linux-2.4.27-rc5]# 

> ----------------------------------------
> From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Sent: Sun Aug 08 01:05:24 CEST 2004
> To: <inet6@mail.be>
> Subject: Re: compile error ip6t_REJECT.c and 2.4.27-rc5
> 
> 
> 
> Hi,
> 
> From: Robby <inet6@mail.be>
> Date: Sat, 7 Aug 2004 21:36:34 +0200 (CEST)
> 
> > I'm getting an error as you can see below, there was also something with ULOG that errored,
> > but since I didn't need that I went back in menuconfig and disabled it.
> > This is with the patch-o-matic-ng CVS of 07/08/2004 at 13:14 CEST.
> > It used to compile before (back with 2.4.25-rc3 and I still have it running).
> > The machine is a RH7.3 box.
> 
> Oh, this is for 2.6 kernel. You can get reject target for 2.4 kernel
> from http://cvs.netfilter.org/cgi-bin/viewcvs.cgi/*checkout*/patch-o-matic-ng/REJECT/linux/net/ipv6/netfilter/ip6t_REJECT.c?rev=1.1
> 
> Harald, why don't you rescue version 1.1 from CVS tree for 2.4 kernel ?
> 
> -----------------------------------------------------------------
> Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
> 
> 
> 
> 

-----------------------------------------------------
Mail.be, WebMail and Virtual Office
http://www.mail.be
