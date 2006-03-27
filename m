From: "James D. Nurmi" <jdnurmi+nfdev@gmail.com>
Subject: Re: Documentation for libnetfilter_conntrack
Date: Mon, 27 Mar 2006 16:45:21 -0700
Message-ID: <a1f5b31e0603271545r28f9eb9ax6bfbd9df5da58d37@mail.gmail.com>
References: <a1f5b31e0603271224q5fa5bd4fi779250ae1396ec43@mail.gmail.com>
	<44284C51.7020908@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@eurodev.net>
In-Reply-To: <44284C51.7020908@eurodev.net>
Content-Disposition: inline
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

On 3/27/06, Pablo Neira Ayuso <pablo@eurodev.net> wrote:
> Hi James,
>
> I've cc'ed the reply to netfilter-devel.
>
> James D. Nurmi wrote:
> > This isnt a request (specifically), so im not trying to give you work! =
=3D)
> >
> > I've prepared some nominal (but far from complete) documentation via
> > doxygen for libnetfilter_conntrack.  Is there a preferred way for me
> > to offer this back to you or the netfilter.org group?  Send to the
> > list?  File a bug and offer a patch?
>
> just send a patch that applies to SVN to the mailing list, with carbon
> copy to me. Then we can discuss about it.

[ no urls permanant, but they'll be around at least for a few weeks, I susp=
ect ]

Since I suspect you'll tell me it needs to change (not a bad thing! =3D) )
http://machiavelli.qwe.cc/conntrack_docs/curdoc.patch

Full doxygenned html:
http://machiavelli.qwe.cc/conntrack_docs/

Still todo: everything listed in todo, everything marked as unknown
(happy to update as people either let me know what they are, or I
figure them out =3D) ).

I'm not a professional tech-writer, but I feel its a good start to
offer back, and will happily take criticism!

>
> > There's also a few spots where my documentation is spotty (for
> > example, the relatively important expectations stuff, they just werent
> > needed for my code, I want to track connections, not extend them =3D) )=
,
> > and a few places where units are unclear.
>
> Feel free to send me your questions.

Will do, though I feel like I should get this out to you before I
sweat the small stuff (and will gladly fix anything before its
submitted! [or after =3D) ]

>
> --
> Pablo
>

- James
