From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [RFC] matching tproxied packets
Date: Tue, 4 Jun 2002 18:28:37 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020604162837.GA2365@balabit.hu>
References: <20020604145036.GA1295@balabit.hu> <200206041714.47683.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200206041714.47683.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 04, 2002 at 05:14:47PM +0200, Henrik Nordstrom wrote:
> Balazs Scheidler wrote:
> 
> > * use a new state (called TPROXY), which would be applied to all TPROXYed
> >   packets (might interact badly with nat/conntrack).
> 
> It will in no doubt interact badly with connection tracking (and therefore 
> NAT).

ok.

> 
> > * have the tproxy framework mark all packets with an fwmark, and let the
> >   packets in based on the value of fwmark
> 
> Will interact badly with fwmark based routing.

of course the mark value would be controlled by the user, and not assigned
automatically.

> > * have a separate match (called tproxy), which matches tproxied sessions
> >   based on some value stored in the associated conntrack entry
> 
> Defenitely my preference, but I might be biased as I make heavy use of 
> connection tracking and fwmark based routing in combination.

This was my conclusion as well. So I'll go for this solution.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
