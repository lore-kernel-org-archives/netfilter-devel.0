From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [RFC] unidirectional NAT
Date: Wed, 12 Jun 2002 12:43:37 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020612104337.GA18405@balabit.hu>
References: <20020605100657.GA10488@balabit.hu> <Pine.LNX.4.33.0206051209270.8715-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206051209270.8715-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 05, 2002 at 12:11:32PM +0200, Jozsef Kadlecsik wrote:
> On Wed, 5 Jun 2002, Balazs Scheidler wrote:
> 
> > Let me think a bit about it. For UDP packets I don't really need
> > conntracking sessions, I only need to translate single packets, but I'd like
> > to avoid messing with IP and UDP header translation myself.
> >
> > So NOTRACK is good for me, I don't need NONAT since I don't need conntrack
> > either. The question is how you mark an skb to avoid tracking? (an idea was
> > to use a flag in nfct, is it still true?)
> 
> No, I'll go with Rusty's solution: a dummy conntrack entry is used.
> 
> > Is you patch available somewhere?
> 
> Not yet, but real soon I'll post it :-).

Can you send me what you have available? I'd like to close my transparency
project, and so I'd be willing to contribute to the conntrack exemption
project :)

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
