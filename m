From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] iptables: ip6table version support and
 libip6t_multiport.fix
Date: Mon, 02 Oct 2006 13:46:32 +0900 (JST)
Message-ID: <200610020446.k924kYkj027138@toshiba.co.jp>
References: <cd6061db0609101806g45614b09t25b42dd510385de3@mail.gmail.com>
	<cd6061db0610011837u5c9419ecld21645cabab37661@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ljlane@debian.org
In-Reply-To: <cd6061db0610011837u5c9419ecld21645cabab37661@mail.gmail.com>
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


Hello,

From: "Laurence J. Lane" <ljlane@debian.org>
Date: Sun, 1 Oct 2006 21:37:54 -0400

> On 9/10/06, Laurence J. Lane <ljlane@debian.org> wrote:
> =

> > details: http://bugs.debian.org/329775
> >
> > The 329775-submitter@bugs.debian.org address reaches all
> > interested Debian parties.
> >
> > R=E9mi Denis-Courmont has submitted a patch to that adds version su=
pport
> > to ip6tables and updates libip6t_multiport to v1. (R=E9mi also post=
ed to the
> > list but something appears to have gone wrong.)
> >
> > It Works for Me.
> =

> I guess the list software ate the attachment.

Great! I'll read deeply that.

> +static void
> +parse_multi_ports_v1(const char *portstring,
> +		     struct xt_multiport_v1 *multiinfo,
> +		     const char *proto)
> +{
> +	char *buffer, *cp, *next, *range;
> +	unsigned int i;
> +	u_int16_t m;
> +
> +	buffer =3D strdup(portstring);
> +	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
> +
> +	for (i=3D0; i<XT_MULTI_PORTS; i++)
> +		multiinfo->pflags[i] =3D 0;
> +
> +	for (cp=3Dbuffer, i=3D0; cp && i<XT_MULTI_PORTS; cp=3Dnext, i++) {

Please use IP6T_MULTI_PORTS so that we can compile with linux 2.4.

Regards,

-- Yasuyuki Kozakai
