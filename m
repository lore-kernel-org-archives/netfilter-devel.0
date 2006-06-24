From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: concerning p-o-m fixes for 2.6.17 API change
Date: Sat, 24 Jun 2006 09:13:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0606240900140.26102@bizon.gios.gov.pl>
References: <1151096311.3421.10.camel@murdegern.hindenburgdamm.example>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1707284606-1151133225=:26102"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1151096311.3421.10.camel@murdegern.hindenburgdamm.example>
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

---187430788-1707284606-1151133225=:26102
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 23 Jun 2006, Torsten Luettgert wrote:

> Hi list,
>
> I noticed the match/target API changed a bit in 2.6.17,
> so a bunch of code in patch-o-matic-ng needs updates.
> I fixed ipp2p, ROUTE, time, and u32 (it's quite trivial).
>
> I'd like to submit the patches (and thus work against the
> "bit-rot" we all hate). Problem is, they are quite clumsy -
> the correct way IMHO is to copy the latest kernel directory
> (normally linux-2.6/) to linux-2.6.17 and then fix that,
> so 2.6.16 and older kernels still work, too. So you can't
> see what is happening in the patches, they just create 99%
> identical copies of the old files.
>
> Patrick, I guess you're the one to ask - would you like
> those patches, and in what format?

As for time and ipp2p current pom-ng contains versions for 2.6.16 and=20
2.6.16.x (-stable) kernels. There is no need to keep patches for that=20
kernels since anyone interesed in older kernels than 2.6.17 is able to=20
take older pom-ng tarball. So, please send ipp2p and time (with CC to me)=
=20
and patches that only corrects API in the "linux-2.6" directory . The same=
=20
advise is probably correct for both ROUTE and u32 but I think Patrick=20
should confirm this.

Thanks.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1707284606-1151133225=:26102--
