From: Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>
Subject: Re: "Kernel bug detected [...]
 nf_ct_del_from_dying_or_unconfirmed_list"
Date: Mon, 28 Jan 2019 15:13:17 +0100
Message-ID: <20190128141317.pxq7vklx346bv2bu@breakpoint.cc>
References: <20190127214708.GC1788@otheros>
 <20190127224822.lsagihtfiuvxyool@breakpoint.cc>
 <CALJUYjOq-xpjorsfnMRthzmC+iuDTVOPHXRb2p3ahU248Jrw4w@mail.gmail.com>
 <20190128133940.jxwuscyi2wvbfb52@breakpoint.cc>
 <20190128135030.xmtngyqaq3p74iug@salvia>
 <CALJUYjO4=pDT0COGJRx2YWDMiEJTpa2CdqQqxndd93khVDZHjA@mail.gmail.com>
Reply-To: The list for a Better Approach To Mobile Ad-hoc Networking
 <b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org,
 Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>
To: Chieh-Min Wang <chiehmin18-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALJUYjO4=pDT0COGJRx2YWDMiEJTpa2CdqQqxndd93khVDZHjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

Chieh-Min Wang <chiehmin18-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I think 71d8c47fc653711c4(netfilter: conntrack: introduce clash
> resolution on insertion race) is doing the same logic for resolving
> conntrack clashing.

No, that commit dealsl with the case where two skbs have different
conntrack objects but where tuples are the same.

In nfqueue+bridge flood case the skbs point to the same conntrack
object.

Maybe one way to fix this would be to let nfqueue perform a deep
copy of skb->_nfct in case conntrack is unconfirmed and skb_shared()
is true.

But that would of course cause drop for l4 protocols that do not support
clash resolution.
