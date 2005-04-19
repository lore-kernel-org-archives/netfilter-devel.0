From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: nfnetlink/ctnetlink - OOPS&panic
Date: Tue, 19 Apr 2005 17:04:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504191659520.8375@bizon.gios.gov.pl>
References: <Pine.LNX.4.62.0504191220390.27543@bizon.gios.gov.pl>
	<4264F3B6.9010408@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-618821809-1113923076=:8375"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4264F3B6.9010408@eurodev.net>
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

---187430788-618821809-1113923076=:8375
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 19 Apr 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>> Hello,
>>=20
>> I have just compiled 2.6.11.7 kernel with nfnetlink/ctnetlink support (f=
rom=20
>> pom-ng-20050418). Unfortunately, during system startup, kernel panics:
>>=20
>> Unable to handle kernel NULL pointer dereference at virtual address=20
>> 000000b3
>>  printing eip:
>> *pde =3D 00000000
>> Oops: 0000 [#1]
>> PREEMPT
>> Modules linked in: bonding
>
> You've catch a race condition.
>
> Since you've compiled nfnetlink and ctnetlink in kernel, not as module, i=
t=20
> seems that ctnetlink registers the subsystem via nfnetlink_subsys_registe=
r=20
> before nfnetlink has created the netlink socket. Then you've received an=
=20
> event that has been sent to a non-existing netlink socket. I can cook an =
oops=20
> with that.
>
> I'll fix it as soon as I get some spare time.

Hm.. I think I have just solved my problem. All I need to do is remove=20
CONFIG_IP_NF_QUEUE=3Dy. It is not possible to load nfnetlink/ctnetlink=20
modules with CONFIG_IP_NF_QUEUE and kernel oops when both options=20
(CONFIG_IP_NF_QUEUE&CONFIG_IP_NF_CONNTRACK_NETLINK/CONFIG_NETFILTER_NETLINK=
)=20
are linked statically.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-618821809-1113923076=:8375--
