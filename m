From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] multiple changes/fixes
Date: Sat, 28 Aug 2004 03:03:06 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040828010306.GD2416@eychenne.org>
References: <20040827133700.GT23981@eychenne.org> <412F5A3C.1000704@trash.net>
	<20040827162808.GA29915@eychenne.org> <412F94D6.8040906@trash.net>
	<20040828000124.GB2416@eychenne.org>
	<Pine.LNX.4.61.0408280202470.10193@filer.marasystems.com>
	<20040828004039.GC2416@eychenne.org>
	<Pine.LNX.4.61.0408280248010.10624@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0408280248010.10624@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Aug 28, 2004 at 02:50:17AM +0200, Henrik Nordstrom wrote:

> On Sat, 28 Aug 2004, Herve Eychenne wrote:

> >Yes... run indent on the current tree, run indent on the patched tree,
> >and run diff on the two "indented" trees. But... too late: I took one
> >hour to remove the fluff from my patch (sigh).

> Found yet another useful tool for splitting patches with less=20
> dependencies: tkdiff

I use it all the time, but I don't really see how it can help to
split patches affecting multiple files efficiently (you're talking
about the merge functionnality, aren't you?), as it works with two
versions of a file at a time, and not a diff file nor 2 trees...

> >I'll post 2 new patches tonight (if my head does not fall heavily on m=
y
> >keyboard til then): one containing the information, the other containi=
ng
> >syntaxical or cosmetic changes, and typo fixes.

> Great!

Maybe I've talked a little bit too fast, as the patch modified by hand
doesn't apply anymore, and I cannot get it to apply even when playing
with rediff and recountdiff (from the patchutils).

> And thanks for encouraging me to look for tools doing this job easier. =
Was=20
> more things around than I expected to find.

You're welcome... ;-)

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
