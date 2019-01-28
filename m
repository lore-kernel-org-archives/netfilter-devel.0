From: Chieh-Min Wang <chiehmin18-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: "Kernel bug detected [...]
 nf_ct_del_from_dying_or_unconfirmed_list"
Date: Mon, 28 Jan 2019 21:35:12 +0800
Message-ID: <CALJUYjOq-xpjorsfnMRthzmC+iuDTVOPHXRb2p3ahU248Jrw4w@mail.gmail.com>
References: <20190127214708.GC1788@otheros>
 <20190127224822.lsagihtfiuvxyool@breakpoint.cc>
Reply-To: The list for a Better Approach To Mobile Ad-hoc Networking
 <b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>
Return-path: <b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20190127224822.lsagihtfiuvxyool-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
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

I think this is the same issue as this one.

http://patchwork.ozlabs.org/patch/995825/

Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org> =E6=96=BC 2019=E5=B9=B41=E6=9C=8828=E6=97=
=A5 =E9=80=B1=E4=B8=80 =E4=B8=8A=E5=8D=886:51=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Linus L=C3=BCssing <linus.luessing-djzkFPsfvsizQB+pC5nmwQ@public.gmane.org> wrote:
> > This only happens upon sending a SIGTERM to the network manager
> > "netifd" (so upon network shutdown). And only if the node is connected
> > to mesh of reasonable size, so if there is a certain amount of
> > multicast traffic for the multicast-to-multi-unicast patch to work on.
>
> Does this still trigger when you do
>
> nf_reset(newskb);
>
> after skb_copy()?
>
> > One difference is that the broadcast flooding adds a bit of
> > delay between each transmission. Which the multicast-to-multi-unicast
> > doesn't.
>
> Are those transmits done asynchronously?
>
> conntrack assumes exclusive access to skb->nfct if the conntrack
> entry isn't in main hash table.
>
> (i.e, when nf_ct_is_confirmed returns false).
>
> > "In nfqueue, two consecutive skbuffs may race to create the conntrack
> >  entry. Hence, the one that loses the race gets dropped due to clash in
> >  the insertion into the hashes from the nf_conntrack_confirm() path."
> >
> > This patch is only part of >=3D 4.18, so not part of the firmware we us=
e
> > yet. Could this issue somehow be related?
>
> Possible, but I don't think its likely.
> In the nfquee case there is asynchronous processing, but
> no skb can share the same conntrack entry unless the entry is already
> in the conntrack hash table.
>
> > Other than that I was wondering whether we might be missing to
> > reset something after skb_copy()-ing. We do a "skb->protocol =3D
> > htons(ETH_P_BATMAN)" right before the dev_queue_xmit(skb) call in
> > batman-adv which sends the encapsulated frame into the
> > mesh. And we do a nf_reset(skb) after decapsulating a frame
> > received from the mesh. But maybe that is not enough?
>
> I suggest nf_reset() on xmit, if you can be sure that the xmit
> won't occur back-to-self (netns case is fine, as skb scrubbing
> resets skb nfct anyway) and the skb isn't on a rexmit list somewhere.
> (clone is fine, only shared skb would break).
