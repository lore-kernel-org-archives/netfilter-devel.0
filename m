From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] multiple changes/fixes
Date: Sat, 28 Aug 2004 02:40:39 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040828004039.GC2416@eychenne.org>
References: <20040827133700.GT23981@eychenne.org> <412F5A3C.1000704@trash.net>
	<20040827162808.GA29915@eychenne.org> <412F94D6.8040906@trash.net>
	<20040828000124.GB2416@eychenne.org>
	<Pine.LNX.4.61.0408280202470.10193@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0408280202470.10193@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Aug 28, 2004 at 02:32:19AM +0200, Henrik Nordstrom wrote:

> There is several tools doing a very good job of cleaning up indentation=
=20
> and formatting. My favorite for C code is indent. There is no need of=20
> doing this by hand.

> On the other hand the same tool can be used to identify the real change=
s=20
> "after the fact" even if the original code was a mess, simply by diffin=
g=20
> the modified version with an original version formatted by the same too=
l.

Yes... run indent on the current tree, run indent on the patched tree,
and run diff on the two "indented" trees. But... too late: I took one
hour to remove the fluff from my patch (sigh).
I'll post 2 new patches tonight (if my head does not fall heavily on my
keyboard til then): one containing the information, the other containing
syntaxical or cosmetic changes, and typo fixes.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
