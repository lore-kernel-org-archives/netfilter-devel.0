From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Connlimit and linux-2.6.17
Date: Thu, 20 Jul 2006 00:39:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607200026310.4015@bizon.gios.gov.pl>
References: <44BEA42B.3000304@andybev.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-822910747-1153348776=:4015"
Cc: martin.bene@icomedias.com, netfilter-devel@lists.netfilter.org,
	kraxel@bytesex.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Beverley <andy@andybev.com>
In-Reply-To: <44BEA42B.3000304@andybev.com>
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

---187430788-822910747-1153348776=:4015
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 19 Jul 2006, Andrew Beverley wrote:

> I (and others, see netfilter list) are having trouble compiling kernel=20
> 2.6.17.4 and iptables-1.3.5-20060508 to use connlimit. Once compiled in a=
nd=20
> I run:
>
> iptables -t mangle -A PREROUTING -p tcp -i eth0 -m \
> =09connlimit --connlimit-above 5 -j LOG
>
> I get "iptables: Invalid argument", and dmesg tells me "ip_tables:=20
> connlimit match: invalid size 0 !=3D 16"
>
> The kernel and iptables are patched with connlimit from=20
> patch-o-matic-ng-20060626, which in turn is patched as per=20
> http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3456 to upda=
te=20
> the connlimit patch.
>
> I have noticed that when compiling the kernel I get error messages as
> follows when compiling connlimit:
>
> net/ipv4/netfilter/ipt_connlimit.c:211: warning: initialization from=20
> incompatible pointer type
> net/ipv4/netfilter/ipt_connlimit.c:212: warning: initialization from=20
> incompatible pointer type
> net/ipv4/netfilter/ipt_connlimit.c:213: warning: initialization from=20
> incompatible pointer type
>
> The code in question is the highlighted lines below:
>
> static struct ipt_match connlimit_match =3D {
>        .name =3D "connlimit",
>        .match =3D &match,               <--
>        .checkentry =3D &check,          <--
>        .destroy =3D &destroy,           <--
>        .me =3D THIS_MODULE
> };
>
> The above error messages do not appear when using 2.6.15, and connlimit=
=20
> works.
>
> Any ideas?
>
> On another note, is it possible for connlimit to form part of the stable=
=20
> kernel? It is a real pain having to mess around patching each time I get =
a=20
> new kernel, especially as currently the patch-o-matic also requires=20
> patching!

Yes, the API was changed in 2.6.17, so small fixes are required to allow=20
extensions to work. I'm currently traveling a lot so connlimit & TARPIT is=
=20
still on my TODO list. I'm going to finish it ASAP but with limited=20
GPRS/EDGE access it is not so simple.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-822910747-1153348776=:4015--
