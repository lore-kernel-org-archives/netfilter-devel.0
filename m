From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] patch-o-matic-ng patch
Date: Tue, 17 Feb 2004 10:48:34 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402171029070.10727-100000@blackhole.kfki.hu>
References: <20040214204204.GX7756@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040214204204.GX7756@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald!

On Sat, 14 Feb 2004, Harald Welte wrote:

> > Please consider applying the attached patch on top of patch-o-matic-ng.
> > The new features implemented in the patch are:
>
> Thank you very much, I will regard this as the best birthday present
> I have received this year ;)

Happy birthday! :-)

> > Working on patch-o-matic-ng I believe one more important thing is
> > still missing. In the current shape p-o-m-ng is more tailored for
> > 'feature' patches, and not for tiny bugfixes.
> > [...]
> > If you agree with such modifications, I can start implementing the
> > required code.
>
> At the workshop last year, I think we agreed to not put bugfixes into
> patch-o-matic anymore.  The general idea was to
>
> 1) not require people to run a special program for just fixing bugs
> 2) not blow up patch-o-matic any further
> 3) not require us to release a new patch-o-matic with every bugfix
>
> However, I'm not sure whether this is still the right decision.  What
> about a bit of both?
>
> Maybe we don't include any bugfixes in pom-ng, but rather put them as
> patches somewhere in our FTP tree, but have pom-ng automatically fetch
> those fixes via http/ftp on demand.
>
> As long as the fixes remain plain patches, people have the choice to
> a) download them as patch and apply it by hand
> b) use any kind of pom-ng release, but still get the most up-to-date
>    security fixes?

It's tempting to integrate fixes into pom-ng: we could rely on the
version-checking/enforcing feature and the help (description) files could
also be kept. But I see the strong arguments on keeping the fixes
separated.

What about a plugin in Netfilter_POM.pm which would look into a hardcoded
place (say ../fixes) and if it's found with patches, automatically adds
them to the candidates? (Network is not always available.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
