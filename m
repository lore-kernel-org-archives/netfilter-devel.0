From: Wichert Akkerman <wichert@wiggy.net>
Subject: Re: building libctnetlink
Date: Sat, 26 Mar 2005 13:31:31 +0100
Message-ID: <20050326123130.GW23991@wiggy.net>
References: <423BF227.8030502@outerspace.dyndns.org>
	<423BF4DC.2070902@outerspace.dyndns.org>
	<1111335091.2523.46.camel@lap-ufomechanic>
	<1111335425.2523.49.camel@lap-ufomechanic>
	<423DF940.100@eurodev.net>
	<1111412190.2716.55.camel@lap-ufomechanic>
	<423F007F.2060102@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <423F007F.2060102@eurodev.net>
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

Previously Pablo Neira wrote:
> yes, type automake before.

Or use autoreconf, which seems to be the magic-du-jour to generate all
the necessary bits.

Wichert.

-- 
Wichert Akkerman <wichert@wiggy.net>    It is simple to make things.
http://www.wiggy.net/                   It is hard to make things simple.
