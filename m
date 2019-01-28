From: Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>
Subject: Re: "Kernel bug detected [...]
 nf_ct_del_from_dying_or_unconfirmed_list"
Date: Mon, 28 Jan 2019 15:01:40 +0100
Message-ID: <20190128140140.mw6updk4v4ougrwz@breakpoint.cc>
References: <20190127214708.GC1788@otheros>
 <20190127224822.lsagihtfiuvxyool@breakpoint.cc>
 <CALJUYjOq-xpjorsfnMRthzmC+iuDTVOPHXRb2p3ahU248Jrw4w@mail.gmail.com>
 <20190128133940.jxwuscyi2wvbfb52@breakpoint.cc>
 <20190128135030.xmtngyqaq3p74iug@salvia>
Reply-To: The list for a Better Approach To Mobile Ad-hoc Networking
 <b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org,
 Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Chieh-Min Wang <chiehmin18-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>
Return-path: <b.a.t.m.a.n-bounces-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190128135030.xmtngyqaq3p74iug@salvia>
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

Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org> wrote:
> I don't think letting the packet go through is a good idea. Not sure
> NAT will work fine, packets would go through being unmangled? I think
> we should still drop the packet until we fix this.

Unfortuntely this is still a band-aid solution, nfqueue + bridge doesn't
work when mcast/flood is involved.

Problematic cases are NAT (several bindings on same conntrack
simultaneously) and extension realloction.
They are not a problem in most cases due to prealloced space and
because extensions are commonly added before bridge starts to clone
for flooding.

For NAT, the race window is small and iirc we changed nat core to
just warn in case the nat bit is already set.

I think it will work fine in most cases with this patch (i.e.,
witch accept verdict) though; it is better than what we do now.
