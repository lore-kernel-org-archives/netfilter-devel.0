From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: extra conntrack stats
Date: Fri, 2 May 2003 23:51:07 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305022341120.7706-100000@blackhole.kfki.hu>
References: <1051878601.3825.6.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Rusty Russell <rusty@rustcorp.com.au>, Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1051878601.3825.6.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 2 May 2003, Martin Josefsson wrote:

> On Fri, 2003-05-02 at 14:18, Jozsef Kadlecsik wrote:
>
> > I'm working on an updated raw patch (+ splitted up to internal logging +
> > raw patches) and an updated and further tuned tcp window tracking patch (+
> > splitted up to proc + tcp window tracking patches). It'll take probably
> > one more week and then I'll submit a patch on a better hash function for
> > conntrack.
>
> While on the subject of the raw patch, please don't forget to add the
> fix for the NFC_ clash I added to cvs a little while ago. The
> userspace/raw.patch depends on pending/27_include-nfc-order.patch

I noticed it and the new patch takes into account the clash.

> Can I get a feature-request? :)
> -j NOTRACK --only-search
>
> that would be nice, search the hashtables but don't allocate new entries
> if not found and if not found mark as UNTRACKED. It will do the same as
> dropping --state NEW later but avoids the alloc and init.

Maybe it's too late, but I don't understand you:

- the raw table has got no notion on conntrack
- conntrack skips the packet "marked" by the NOTRACK target of the raw
  table. No new hash table entries are generated, one dummy entry is used
  for every untracked packet.
- packets "marked" with NOTRACK has got the state UNTRACKED

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
