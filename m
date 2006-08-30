From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Problems with standalone ipp2p compilation
Date: Wed, 30 Aug 2006 22:39:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0608302237440.27719@bizon.gios.gov.pl>
References: <44F5B4C4.3070707@arcoscom.com> <44F5B6B9.5090209@arcoscom.com>
	<20060830191624.GA17624@ekonomika.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-157294985-1156970359=:27719"
Cc: ipp2p@ipp2p.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Samuel D?az Garc?a <samueldg@arcoscom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
In-Reply-To: <20060830191624.GA17624@ekonomika.be>
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

---187430788-157294985-1156970359=:27719
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 30 Aug 2006, Steven Van Acker wrote:

> On Wed, Aug 30, 2006 at 06:03:05PM +0200, Samuel D?az Garc?a wrote:
>> Notes to get FC5 iptables sources (I forgot them before), as root:
>>
>> #> yumdownloader --source iptables
>> #> rpm -ihv iptables-1.3.5-1.2.src.rpm
>> #> rpmbuild -bp /usr/src/redhat/SPECS/iptables.spec
>> #> ln -fs /usr/src/redhat/BUILD/iptables-1.3.5 /usr/src/iptables
>>
>> Regards
>
> Hi,
>
> I was unable to compile ipp2p for 2.6.17.11 untill I patched it with
> this patch:
> http://www.sieglitzhof.net/~doc/ipp2p/patch-ipp2p-0.8.1_rc1_v2.6.17.diff

Why didn't you take a recent pom-ng and download it from a external=20
repository (./runme --download)?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-157294985-1156970359=:27719--
