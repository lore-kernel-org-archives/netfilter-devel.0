From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] multiple changes/fixes
Date: Sat, 28 Aug 2004 02:01:24 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040828000124.GB2416@eychenne.org>
References: <20040827133700.GT23981@eychenne.org> <412F5A3C.1000704@trash.net>
	<20040827162808.GA29915@eychenne.org> <412F94D6.8040906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <412F94D6.8040906@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Aug 27, 2004 at 10:08:54PM +0200, Patrick McHardy wrote:

Disclaimer for overbooked netfilter people: this email is perfecly
uninteresting.

> Herve Eychenne wrote:

> >On Fri, Aug 27, 2004 at 05:58:52PM +0200, Patrick McHardy wrote:
> >
> >>Would it be possible that you split the patch into logical changes
> >>so it's easier to review ?
> >>
> >
> >I was afraid someone would say that. Does someone know a good tool to
> >split patches? I think of a X11 that would enable to drag and drop
> >diff file portions to several new areas/patches, with an option that
> >would automatically create one containing only whitespace changes.

> Unfortunately, no. I use bitkeeper, patch and cut-n-paste for that, but
> that's just my preference.

I certainly wouldn't allow any of my libre work to rely on processes
using a "non-libre" application. Question of survival.
Anyway, I don't want to create a holy war here, a certain G.W.B.
is already doing fine stuff in this area. :-)

BTW, I cannot imagine that an application enabling to wipe
spacechanges-only from a patch does not currently exist... Eventually,
it could wipe syntaxical changes only (but should be aware of the
language structure/grammar), but that's harder, of course. So many
things to do, and so little time...

> > Otherwise I guess I may not have the courage to do it. :-(

> I hope you're still going to do it.

When I think about the time it would take me to do that, compared to the
relatively small overhead of having to ignore obvious cosmetic changes
during the review, I'm still quite sceptical about it... :-(

> I don't want to throw in a 70k
> patch which touches stuff all over the place, and it's really hard
> to judge which change has which purpose

I don't think it's that hard. But I'm not objective, as I wrote it. :-)
The changes are simple, it's just that there are plenty of them.
Yet, I can understand your reluctance.

> with just one big patch that also reindents and reformats stuff.

I know I'm a bad boy, but if I didn't do these as I was wandering
through the code, I would never have done it afterwards, and I still
think it was worth cleaning a little bit. Readability is often
more important than one thinks.

> BTW:

> -static int print_match(const struct ip6t_entry_match *e,
> -                       const struct ip6t_ip6 *ip)
> -{
> +static int
> +print_match(const struct ip6t_entry_match *e, const struct ip6t_ip6 *i=
p) {

> the opening bracket should be on a seperate line.

For functions only (argh)...
Oh, you're right. The global coding style of the tree is quite
different from mine (I particularly hate 8 spaces indentation, but
we all know Linus was sent by hell, right? ;-), so I guess I may
sometimes have been trapped into unconsciously bringing it closer to
mine.
But maybe you'll notice that the (this) coding style is far from having
been applied everywhere in the current tree, as multiple people wrote
different parts, obviously.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
