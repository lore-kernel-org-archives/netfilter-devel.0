From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Mon, 4 Apr 2005 10:07:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504040852460.12853@blackhole.kfki.hu>
References: <20050317032405.GA7200@roonstrasse.net>
	<20050401055819.GH19835@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Max Kellermann <max@duempel.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050401055819.GH19835@sunbeam.de.gnumonks.org>
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

Hi,

On Fri, 1 Apr 2005, Harald Welte wrote:

> On Thu, Mar 17, 2005 at 04:24:05AM +0100, Max Kellermann wrote:
> > this patch implements a "real" H.225 parser, replacing the old "brute
> > force" algorithm. This parser is not complete yet; it currently only
> > handles CONNECT packets, although that seems to be enough for most
> > H.323 clients. I tested with ohphone, MS Netmeeting and gnomemeeting
> > (plus a nfsim test which I will publish soon). NAT works well.
>
> First of all, thanks for your excellent work on this.  However, I'm not
> sure whether to apply the patch, since I don't have any test setup for
> h.323.
>
> Jozsef: what do you think of that patch? h.323 helper is your code,
> after all.

Max does the right thing. And as he completes the helper with the H.245
parser, we could finally consider to push the helper into the kernel. :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
