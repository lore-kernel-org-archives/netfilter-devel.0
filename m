From: Herve Eychenne <rv@wallfire.org>
Subject: Re: SNAT from multiple interfaces with the same IP?
Date: Mon, 5 Dec 2005 00:35:57 +0100
Message-ID: <20051204233557.GB5617@eychenne.org>
References: <4392E148.7010102@gmx.net> <43930BEF.9000602@trash.net>
	<20051204153729.GA5617@eychenne.org> <43931301.1040109@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <43931301.1040109@trash.net>
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

On Sun, Dec 04, 2005 at 05:02:09PM +0100, Patrick McHardy wrote:

> Herve Eychenne wrote:
> >On Sun, Dec 04, 2005 at 04:31:59PM +0100, Patrick McHardy wrote:
> >
> >
> >>I don't see why it wouldn't work, but you can't use -i in POSTROUTING
> >>directly,
> >
> >
> >BTW, I've always wondered why exactly...

> Two reasons:

> - The incoming interface is not known anymore in POST_ROUTING

Sorry, but... why? (that was my question indeed)

> - Locally generated packets don't even have an incoming interface

So what?
If you could use -i, then locally generated packets wouldn't match
(that's not a problem because you would do it on purpose).
If you don't, it would work as it used to till now.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
