From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Major problem with conntrack utility and kernel 2.6.14.3
Date: Mon, 5 Dec 2005 11:24:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512051115450.16776@bizon.gios.gov.pl>
References: <4361EAAB.1090206@fliegl.de> <436281BB.2010100@fliegl.de>
	<4392510A.3030400@eurodev.net> <200512041004.37192.romary@nikoon.com>
	<43934BC3.3090107@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1783773809-1133778253=:16776"
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@eurodev.net>, Romary Sonrier <romary@nikoon.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43934BC3.3090107@trash.net>
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

---187430788-1783773809-1133778253=:16776
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 4 Dec 2005, Patrick McHardy wrote:

> Romary Sonrier wrote:
>> Hi evrybody,
>>=20
>> Next week, my main goal at work will to help you to solve this issue.
>> I can reproduce easly the kernel oops with my boxs... I still need few=
=20
>> hours to be able to print the kernel oops on my serial port (because it'=
s=20
>> an embedded system). As soon as possible i will send you the whole messa=
ges=20
>> of the kernel oops.
>> Is there a mean to help you more quicly ? using some tools like strace o=
r=20
>> gdb?
>> I'm far from being on geek okernel deguging.... ;-)
>
> Please try this patch, I hope it will fix the problems you're seeing.
>

This patch also fixed my problem (kernel BUG at kernel/sched.c:2833).=20
Thank you.

Is it possible that this patch and "Fix refcount leak ip_conntrack/nat_prot=
o"=20
(http://www.kernel.org/git/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=
=3Dcommit;h=3D00cb277a4a1fb76aafb2fb28aa99f30546e619c5)=20
will go to next 2.6.14-stable kernel?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1783773809-1133778253=:16776--
