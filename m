From: Patrick Schaaf <bof@bof.de>
Subject: Re: nf_conntrack & NAT
Date: Wed, 7 Dec 2005 08:00:39 +0100
Message-ID: <20051207070039.GC474@oknodo.bof.de>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<20051207070517.GA4361@rama.exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Herve Eychenne <rv@wallfire.org>,
	Jan Kasprzak <kas@fi.muni.cz>, netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <20051207070517.GA4361@rama.exocore.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> > Stateless?  And what if you want the response (of the packets which have
> > been redirected) to come back with their initial address, as if they
> > had not been redirected? (if the client shouldn't know that, if this
> > should be transparent to him)
> 
> then you need a static snat target that does this for all reply packets.

How do you expect to match those reply targets?

Be aware that REDIRECT does not mean REDIRECT-always-for-the-same
source-and-destination-pair. Such thinking would be too restrictive.

For example, I use ipset bitmaps to determine, at conntrack-NEW-time,
whether some connection should be REDIRECTed, or not. This decision,
once made, should stay stable for the same connection, even if the
ipset bitmap is modified wrt to another new connection between the
same partners.

So I at least need conntracking, and some way to _mark_ connections,
if the connection does not store a NAT decision itself. Or my usage
won't be supported for IPv6. (not a problem at the moment, but who
knows)

> stateful IPv6 NAT only over my dead body.  Do you know that NAT is the
> single most destructive way that ever happened to todays internet?  That
> it is the number one reason why VoIP doesn't really take off as much as
> it could?  The number one reason for various non-deterministic breakage
> all over the place? 

All known. All completely nonapplicable for REDIRECT.

best regards
  Patrick
