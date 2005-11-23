From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: nf_conntrack & NAT
Date: Wed, 23 Nov 2005 14:24:19 +0100
Message-ID: <20051123132419.GJ24091@fi.muni.cz>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20051123132044.GZ3249@eychenne.org>
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

Herve Eychenne wrote:
: On Wed, Nov 23, 2005 at 09:25:47PM +0900, Yasuyuki KOZAKAI wrote:
: 
:  Hi,
: 
: > >                                                      and adding NAT 
: > > support for IPv6?
: 
: > Never ever. You can learn why people don't want to do it from many sources.
: > For example, You can use many addresses in IPv6 world. And I don't want people
: > get troubles due to NAT traversal issues in IPv6 world.
: 
: And what if you want your firewall to transparently redirect some traffic
: to another host, for example?
: 
	... or IPVS-based clusters. NAT functionality is definitely
wanted (even though full NAT in the IPv6 world is evil :-).

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> Specs are a basis for _talking_about_ things. But they are _not_ a basis <
> for implementing software.                              --Linus Torvalds <
