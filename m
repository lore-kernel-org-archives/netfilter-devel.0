From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Connlimit and linux-2.6.17
Date: Fri, 21 Jul 2006 22:32:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607212229270.17358@bizon.gios.gov.pl>
References: <44BEA42B.3000304@andybev.com>
	<Pine.LNX.4.64.0607200026310.4015@bizon.gios.gov.pl>
	<44BEB607.3000408@andybev.com>
	<Pine.LNX.4.64.0607212050390.17358@bizon.gios.gov.pl>
	<44C137CF.7020408@andybev.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-541012742-1153513944=:17358"
Cc: martin.bene@icomedias.com, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, adlan.elm@gmail.com, kraxel@bytesex.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Beverley <andy@andybev.com>
In-Reply-To: <44C137CF.7020408@andybev.com>
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

---187430788-541012742-1153513944=:17358
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 21 Jul 2006, Andrew Beverley wrote:

>>>>> I (and others, see netfilter list) are having trouble compiling kerne=
l=20
>>>>> 2.6.17.4 and iptables-1.3.5-20060508 to use connlimit. Once compiled =
in=20
>>>>> and I run:
>>=20
>> OK, I fixed the connlimit extension.
>
> Excellent!
>
>>
>>  - download recent version of patch-o-matic-ng
>>
>>  - remove "patchlets/connlimit" directory from extracted pom-ng
>>
>>  - run "./runme --download"
>
> I've downloaded 20060720 but when I run --download I get:
>
> could not get /index
> could not get http://mynodes.net/pub/linux/netfilter/patchlets/index
> could not get /index
> could not get http://www.nucleus.it/pom-repo/index
> could not get /index
> could not get http://people.netfilter.org/ole/pom//index
>
> and connlimit does not appear. Am I doing something stupid?

It seems you don't have curl installed, which is required to use external=
=20
pom-ng repositories.


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-541012742-1153513944=:17358--
