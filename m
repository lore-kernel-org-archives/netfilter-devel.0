From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Request for maintaining "condition" and "time"
Date: Wed, 11 Jul 2007 09:36:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707110931030.11053@fbirervta.pbzchgretzou.qr>
References: <13732b70707102143y64c43ea0hb7ba564f41b460c3@mail.gmail.com>
	<Pine.LNX.4.64.0707110912440.11053@fbirervta.pbzchgretzou.qr>
	<13732b70707110029k7d71696dta1fbe1c5128298c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-181392576-1184139413=:11053"
Cc: netfilter-devel@lists.netfilter.org
To: "Gustavo Jr. Alves" <gjalves@gjalves.com.br>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <13732b70707110029k7d71696dta1fbe1c5128298c@mail.gmail.com>
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

---699020219-181392576-1184139413=:11053
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Jul 11 2007 04:29, Gustavo Jr. Alves wrote:
>
> I=C2=B4m really new on netfilter (this is why I asking so many dumb
> questions since yesterday), and I had previously understand that
> "time" and "condition" modules has no support at all.

Well, Krzysztof Oledzki <ole [at] ans.pl> is listed in the pomng db
as the maintainer for the time module.

> If you are the maintainer, sorry by asking about it.

I am not :) It is just because I do (plan) to include it in my kernels
too, so there was the opportunity to give ipt_time some cleaning.

> I have no intention to "steal" the projects.
> The same is applied to "condition" module?

It is a free world, you cannot "steal".

BTW,
# condition, maintained by Massimiliano Hofer <max@nucleus.it>

> Anyway, there are anything I can help? And what need to be done to
> pull this module on mainstream?

#1: Convince Patrick the module has its worth :)
#2: x_tables infrastructure
#3: IPv6, if applicable/doable
#4: Logic cleanups (as for ipt_time, I remember rants about timezone supp=
ort*)

[*] Gotta dig up the url...

As for condition, I have not looked at it, and do not plan to.
Feel free to "grab" it :)

> It will be a lot of interesting if we
> can use this resource natively on the distributions.
>
> Thanks
>
> Gustavo
>


	Jan
--=20
---699020219-181392576-1184139413=:11053--
