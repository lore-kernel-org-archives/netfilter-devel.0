From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 05 May 2003 15:07:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1052140078.932.76.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0305051435300.607-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Rusty Russell <rusty@rustcorp.com.au>, Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0305051435300.607-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-05-05 at 14:38, Jozsef Kadlecsik wrote:

> > --only-search wouldn't skip conntrack completely. It still does the
> > search but if no entry is found we don't allocate a new, instead we bail
> > out and set
> >
> > skb->nfct = &ip_conntrack_untracked.infos[IP_CT_NEW];
> >
> > so it from now on looks just like a "regular" -j NOTRACK packet.
> >
> > The purpose of this feature is to still allow outbound connections
> > during a DDoS but deny all new inbound with as little overhead as
> > possible.
> 
> Oh, there is no need for a flag: that was a bug in the NOTRACK target.
> It should have not marked packets belonging to existing connections.
> 
> Thank you for spotting this.

Hehe ok, I thought that was how you wanted it to work.

If the DDoS is _really_ massive you will use -j DROP and not -j NOTRACK
anyway so this change in behaviour would be really nice.
(I see >140kpps DDoS's sometimes)

I don't think there's that many people using NOTRACK so the change
probably won't break any existing configurations.

-- 
/Martin
