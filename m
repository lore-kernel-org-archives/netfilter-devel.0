From: "Miguel Amador L." <amador@puc.cl>
Subject: Re: [Fwd: ACCEPT/DROP]
Date: Tue, 24 Dec 2002 13:57:15 -0300 (-0300)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.OSF.4.40.0212241356310.2013-100000@uro.crisol.puc.cl>
References: <Pine.LNX.4.44.0212241649520.27999-100000@el-zoido.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Markus Schaber <markus.schaber@student.uni-ulm.de>,
    "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.44.0212241649520.27999-100000@el-zoido.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Me too...
I am interested in the sources..

On Tue, 24 Dec 2002, Patrick McHardy wrote:

> Hi,
>
> On Sat, 21 Dec 2002, Markus Schaber wrote:
>
> > Hallo,
> >
> > Venkatesh Prasad Ranganath <vranganath@cox.net> schrieb:
> >
> > > I was looking into the iptables implementation and was intrigued about
> > > how iptables would handle a situation in which we have identical rules
> > > except for their targets which are contradicting, say ACCEPT and DROP.
> >
> > This is a problem that _must_ be solved by the human being, because
> > equality of rules (as for other computer code) _cannot_ be computed.
>
> This may be true for code, but iptables rules describe sets of packets
> and you can detect identical rules (or rules which describe
> subsets/supersets) if you have knowledge what a particular match matches.
>
> > (Equality of code is a broad area in computer science, e. G. a compiler
> > maker should be able to prove that the code after the optimization is
> > equal to the code before. It there is no general algorithm to prove the
> > equality of code, and it is proven that such an algorithm cannot exist,
> > except for very special cases. If you're interested in this subject, I
> > can give you some sources.)
>
> I am interested, please point me where to read more about this ..
>
> Bye,
> Patrick
>
>
>


 Miguel Angel Amador Lorca    |    mailto:amador@puc.cl
 "No sabiamos que era imposible,  por eso lo hicimos ... "
