From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [ADMIN] patch-o-matic cleanup
Date: Thu, 29 Sep 2005 15:09:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0509291445460.20138@bizon.gios.gov.pl>
References: <20050919151533.GF12075@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-401102677-1127999391=:20138"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050919151533.GF12075@rama.de.gnumonks.org>
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

---187430788-401102677-1127999391=:20138
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 19 Sep 2005, Harald Welte wrote:

> Hi!
Hi!

> Following up to the bad experience over the last couple of months,
> Patrick and me decided that we'd get rid of a lot of code in
> patch-o-matic.
>
> None of the developers seems to have any time left to put into backwards
> compatibility, and the idea of explicit "patch o matic maintainers" that
> we tried some two years ago also didn't work out.
>
> Therefore, the current best practise seems to be:
>
> 1) get rid of any code in patch-o-matic that has already included in
>   mainline (I've already remove tons of directories today)
> 2) stop supporting anything than the most current version of a patchlet.
>
> Sorry, but it really wasn't of any use to provide outdated unmaintained
> and unfixed old versions of the code.

What is the current status of nf_conntrack? It is not in mainline, it is=20
no longer in pom-ng, either. Where to find it?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-401102677-1127999391=:20138--
