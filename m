From: Phil Oester <kernel@linuxace.com>
Subject: Re: DaveM get's removed from Cc (was Re: [PATCH 1/2] string match
	for iptables)
Date: Fri, 26 Aug 2005 08:21:21 -0700
Message-ID: <20050826152121.GB5606@linuxace.com>
References: <43075517.3070405@eurodev.net> <43075BEA.1030701@trash.net>
	<20050820.131403.37427784.davem@davemloft.net>
	<20050825104258.GU4442@rama.de.gnumonks.org>
	<1124988859.28166.28.camel@localhost.localdomain>
	<1124990355.28166.31.camel@localhost.localdomain>
	<430F0442.5030909@trash.net>
	<20050826132743.GZ4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050826132743.GZ4226@rama.de.gnumonks.org>
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

On Fri, Aug 26, 2005 at 03:27:43PM +0200, Harald Welte wrote:
> it's a per-user configuration setting of mailman called "nodupes".  
> 
> If X subscribes to a mailinglist L and sets "nodupes", and Z sends a
> message to L with Cc: X, then X will be removed.

FWIW, most other lists seem to default to 'dupes', but netfilter-devel
defaults to nodupes.  Perhaps the default should be flipped?

Phil
