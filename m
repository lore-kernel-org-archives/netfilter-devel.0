From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: extra conntrack stats
Date: Mon, 5 May 2003 11:24:32 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305051119550.607-100000@blackhole.kfki.hu>
References: <1051912724.3824.41.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Rusty Russell <rusty@rustcorp.com.au>, Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1051912724.3824.41.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 2 May 2003, Martin Josefsson wrote:

> On Fri, 2003-05-02 at 23:51, Jozsef Kadlecsik wrote:
>
> > > Can I get a feature-request? :)
> > > -j NOTRACK --only-search
>
> --only-search wouldn't skip conntrack completely. It still does the
> search but if no entry is found we don't allocate a new, instead we bail
> out and set
>
> skb->nfct = &ip_conntrack_untracked.infos[IP_CT_NEW];
>
> so it from now on looks just like a "regular" -j NOTRACK packet.
>
> The purpose of this feature is to still allow outbound connections
> during a DDoS but deny all new inbound with as little overhead as
> possible.

I see. I'll try to add it without introducing a new NFC flag.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
