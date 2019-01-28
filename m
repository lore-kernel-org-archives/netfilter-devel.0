From: Chieh-Min Wang <chiehmin18-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: "Kernel bug detected [...]
 nf_ct_del_from_dying_or_unconfirmed_list"
Date: Mon, 28 Jan 2019 22:25:30 +0800
Message-ID: <CALJUYjPHSiuM74N11NwKeMLrdQ-q8EEUogfP3eqBm69cyEB=AQ@mail.gmail.com>
References: <20190127214708.GC1788@otheros>
 <20190127224822.lsagihtfiuvxyool@breakpoint.cc>
 <CALJUYjOq-xpjorsfnMRthzmC+iuDTVOPHXRb2p3ahU248Jrw4w@mail.gmail.com>
 <20190128133940.jxwuscyi2wvbfb52@breakpoint.cc>
 <20190128135030.xmtngyqaq3p74iug@salvia>
 <CALJUYjO4=pDT0COGJRx2YWDMiEJTpa2CdqQqxndd93khVDZHjA@mail.gmail.com>
 <20190128141317.pxq7vklx346bv2bu@breakpoint.cc>
 <CALJUYjMM7EJVxxhh_q=607yn7OXhfnhrnk+m=tQ7C8GJjOCDcA@mail.gmail.com>
Reply-To: The list for a Better Approach To Mobile Ad-hoc Networking
 <b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>
To: Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>
Return-path: <b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
In-Reply-To: <CALJUYjMM7EJVxxhh_q=607yn7OXhfnhrnk+m=tQ7C8GJjOCDcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.open-mesh.org/mm/options/b.a.t.m.a.n>,
 <mailto:b.a.t.m.a.n-request-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-mesh.org/pipermail/b.a.t.m.a.n/>
List-Post: <mailto:b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:b.a.t.m.a.n-request-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-mesh.org/mm/listinfo/b.a.t.m.a.n>,
 <mailto:b.a.t.m.a.n-request-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org?subject=subscribe>
Errors-To: b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org
Sender: "B.A.T.M.A.N" <b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
List-Id: netfilter-devel.vger.kernel.org

The point I am clarifying is that with NFQUEUE working on the system.

After resolving clashing using 71d8c47fc6537, it may result to two skb
holding the same conntrack on different core traveling in the
netfilter just like the nfqueue + multicast case.

Chieh-Min Wang <chiehmin18-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =E6=96=BC 2019=E5=B9=B41=E6=9C=8828=
=E6=97=A5 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=8810:16=E5=AF=AB=E9=81=93=EF=
=BC=9A
>
> Yes, I understand the cases are different.
>
> However, the result after resolving clashing will cause two skb point
> to the same conntrack.
> The first skb with confirmed conntrack may not pass through the NAT
> when the second skb resolve clashing?
>
> Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org> =E6=96=BC 2019=E5=B9=B41=E6=9C=8828=E6=97=
=A5 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=8810:13=E5=AF=AB=E9=81=93=EF=BC=9A
> >
> > Chieh-Min Wang <chiehmin18-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > I think 71d8c47fc653711c4(netfilter: conntrack: introduce clash
> > > resolution on insertion race) is doing the same logic for resolving
> > > conntrack clashing.
> >
> > No, that commit dealsl with the case where two skbs have different
> > conntrack objects but where tuples are the same.
> >
> > In nfqueue+bridge flood case the skbs point to the same conntrack
> > object.
> >
> > Maybe one way to fix this would be to let nfqueue perform a deep
> > copy of skb->_nfct in case conntrack is unconfirmed and skb_shared()
> > is true.
> >
> > But that would of course cause drop for l4 protocols that do not suppor=
t
> > clash resolution.
> >
