From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: time match module make error
Date: Wed, 7 Dec 2005 10:33:46 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512071018470.6814@bizon.gios.gov.pl>
References: <000701c5fae6$b3129a10$3406000a@cetchg9lggkx6o>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-450471352-1133948026=:6814"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: chang <future_hacker@yeah.net>
In-Reply-To: <000701c5fae6$b3129a10$3406000a@cetchg9lggkx6o>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-450471352-1133948026=:6814
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 7 Dec 2005, chang wrote:

> hi,all,I download patch-o-matic-ng-20051205.tar.bz2 and=20
> iptables-1.3.4.tar.bz2 from ftp.netfilter.org,and linux-2.6.13.4.tar.bz2=
=20
> from www.kernel.org.but there is some error when i compile them:
>
> -------error messages------------
>
>  CC      net/ipv4/netfilter/ipt_time.o
> net/ipv4/netfilter/ipt_time.c: In function `match':
> net/ipv4/netfilter/ipt_time.c:59: error: structure has no member named `t=
stamp'
> net/ipv4/netfilter/ipt_time.c:60: warning: implicit declaration of functi=
on `__net_timestamp'
> net/ipv4/netfilter/ipt_time.c:63: error: structure has no member named `t=
stamp'
> net/ipv4/netfilter/ipt_time.c:63: error: structure has no member named `t=
stamp'
> net/ipv4/netfilter/ipt_time.c:67: error: structure has no member named `t=
stamp'
> make[3]: *** [net/ipv4/netfilter/ipt_time.o] Error 1
> make[2]: *** [net/ipv4/netfilter] Error 2
> make[1]: *** [net/ipv4] Error 2
> make: *** [net] Error 2
> ---------------------cut here--------------------
>
> so i read the file "ipt_time.c" and find the error is maybe at "skb->tsta=
mp"
> -------ipt_time.c------------------
<CUT>
> ---------------------cut here--------------------
>
> then i read the file "include/linux/skbuff.h",i find there is no the memb=
er "tstamp" in the struct "sk_buff"
>
> --------------------skbuff.h----------------------
<CUT>
> ---------------------cut here--------------------
>
> what should i do,who can help me.thanks.

You simply need more recent kernel (2.6.14.x) or older patch-o-matic-ng.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-450471352-1133948026=:6814--
