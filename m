From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RFC: conntrack hash function comparison II
Date: Thu, 27 Feb 2003 14:18:06 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0302271148260.25458-100000@blackhole.kfki.hu>
References: <20030226171820.GF8883@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030226171820.GF8883@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 26 Feb 2003, Harald Welte wrote:

> On Wed, Feb 19, 2003 at 12:40:56PM +0100, Jozsef Kadlecsik wrote:
> >
> > I have finished my second try to compare the candidate hash functions for
> > conntrack. The very short summary of my findings:
>
> Great news.  I cannot say how much I appreciate somebody spending all
> this time with the statistical analysis of those algorithms.
>
> I trust your judgement and am willing to sacrifice the 'randomness' idea
> of abcde in favor of not having to rehash with the jenkins2b.

I'm in a (long) private conversation with Don Cohen on the hashes. (It's
unfortunate that it was not started on netfilter-devel...)

Currently I believe that there is even a flawn in the abcd hashes.
In a few days (I hope :-) I'll send the final summary to the list.

> > All the graphs and results can be found at
> > http://www.kfki.hu/~kadlec/sw/netfilter/ct2
>
> btw, what do you think of putting the cttest (and the raw testing data)
> into the netfilter CVS repository?   This can be useful if available to
> all interested developers via the usual 'distribution channel'
> (netfilter.org site).

I have been thinking on it. The cttest package was actually written by
Patrick Schaaf, so we need his permission.

Patrick, don't you mind if we put up all the stuff into the cvs
repository?

> I have now added a seperate 'netfilter-testing' repository to CVS for
> this purpose (and future testing tools, like a new testsuite)
>
> It would also be helpful to have the webpages on the netfilter.org
> project site or at least have them linked (whichever you prefer).

It'd better if the pages could be moved to netfilter.org. (~1500 files,
about 10k).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
