From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] note owner match brokenness
Date: Sun, 3 Oct 2004 21:43:30 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041003194330.GG2823@eychenne.org>
References: <20041001204447.GA30390@linuxace.com> <415DC791.3060409@trash.net>
	<20041001211251.GA30542@linuxace.com> <415DCC5E.2030407@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <415DCC5E.2030407@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Oct 01, 2004 at 11:30:06PM +0200, Patrick McHardy wrote:

> Phil Oester wrote:

> >On Fri, Oct 01, 2004 at 11:09:37PM +0200, Patrick McHardy wrote:
> >=20
> >
> >>If we warn in userspace, we should warn when then options are used
> >>instead of in the helptext.
> >>  =20
> >>
> >
> >Agreed, but do we want to:
> >
> >  1) warn on every single use of owner match?
> >  2) have iptables determine if we are running on an SMP box, and
> >     only warn in that case?
> >
> >I didn't think either of these were terribly appealing.
> >=20
> >

> Agreed, I'm going to apply your patch. Thanks.

Please apply the same to the manpage!

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
