From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Mon, 4 Apr 2005 11:28:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504041113480.12929@blackhole.kfki.hu>
References: <20050317032405.GA7200@roonstrasse.net>
	<20050401055819.GH19835@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0504040852460.12853@blackhole.kfki.hu>
	<20050404091035.GB28490@roonstrasse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050404091035.GB28490@roonstrasse.net>
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

Hi Max,

On Mon, 4 Apr 2005, Max Kellermann wrote:

> On 2005/04/04 10:07, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > > Jozsef: what do you think of that patch? h.323 helper is your code,
> > > after all.
> >
> > Max does the right thing. And as he completes the helper with the H.245
> > parser, we could finally consider to push the helper into the
> > kernel. :-)
>
> Jozsef, thanks for confirming my patches. The H.225 parser works for
> the clients I tested, but needs more work, because it *may* break
> other clients (no ASN.1-PER parser, just q'n'd).

It *is* a big step ahead: no more guesswork but parsing. The protocols
behind H.323 plus the underlying ASN.1 coding create a nigthmare and I'm
really impressed someone finally stepped ahead to cope with it.

> I have already written a lean H.245 parser which is working for me. It
> aims to parse the ASN.1-PER correctly, but it has grown more complex
> than I had expected. I will release it after I have spent more time on
> cleanup, review and testing.
>
> Security is my goal #1; what we need least is a remote kernel hole
> (other ASN.1 parsers had holes in the past). This is the most complex
> conntrack helper until now. It has to undergo much more review before
> we can recommend it for the mainstream kernel.

Exactly. Therefore I'd prefer nfsim tests, which do not only check the
functionality but violate the specifications and the parser in the
helper at the cricital points.

> Once the H.245 parser is finished, the H.225 parser will be rewritten
> using my low-level ASN.1-PER parser library.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
