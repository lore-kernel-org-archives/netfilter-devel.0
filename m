From: Julius Volz <julius.volz@gmail.com>
Subject: Re: [bug] FWMARKs and persistence in IPVS: The Use of Unions
Date: Tue, 28 Apr 2009 12:57:51 +0200
Message-ID: <43ca39800904280357q25dd3ec4x50ee78b11a94ba3f@mail.gmail.com>
References: <20090428081509.GA746@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	lvs-devel@vger.kernel.org,
	=?ISO-8859-1?Q?Fabien_Duch=EAne?=
	<fabien.duchene@student.uclouvain.be>,
	Joseph Mack NA3T <jmack@wm7d.net>
To: Simon Horman <horms@verge.net.au>
Return-path: <lvs-devel-owner@vger.kernel.org>
In-Reply-To: <20090428081509.GA746@verge.net.au>
Sender: lvs-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Tue, Apr 28, 2009 at 10:15 AM, Simon Horman <horms@verge.net.au> wro=
te:
> [ Moving to netfilter-devel / lvs-devel for discussion on how to reso=
lve this.
> =A0Added Julius Volz to Cc, he wrote most of the IPv6 portion of LVS.
> =A0Remove lvs-users from Cc, it is not an open list. ]

Thanks for the notice and sorry for the v4 breakage.

> A simple fix that comes to mind is to just store the fwmark in
> the first octet of .all, and set the other octets to zero.
> But is .ip always going to be the same as .all[0]?

I prefer this and would have assumed that it is ok, but maybe someone
else can answer that more confidently.

> Is a different approach required? For example, one where we know to c=
ompare
> .all or perhaps a single octet of .all in the case where fmarks are u=
sed.

I guess that could be done by only specializing the lookup comparisons
in __ip_vs_conn_in_get() and ip_vs_ct_in_get() when the ports are 0.
Would blow up those if-statements even more though...

> This particular change should be easy enough. I believe that fwmarks =
are
> only used in this way twice, both inside ip_vs_schedule(). But
> ip_vs_addr_equal() is more generic, so I'd prefer only to mangle it i=
f
> needed.

I agree.

Julius
