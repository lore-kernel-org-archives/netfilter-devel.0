From: Phil Oester <kernel@linuxace.com>
Subject: Re: [iptables 1.3.0 / libiptc patch] sort chains by hooknum/names
Date: Fri, 4 Mar 2005 14:08:27 -0800
Message-ID: <20050304220827.GA23938@linuxace.com>
References: <20050304212114.130e2a7c@coruscant>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Olaf Rempel <razzor@kopf-tisch.de>
Content-Disposition: inline
In-Reply-To: <20050304212114.130e2a7c@coruscant>
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

On Fri, Mar 04, 2005 at 09:21:14PM +0100, Olaf Rempel wrote:
> hi list
> 
> >From 1.3.0 all chain names were alphabetically sorted when listing tables.
> A user-defined chain 'AAA' is listed before the buildin chain "INPUT", and 
> "FORWARD" is listed before "INPUT".
> 
> I've created two patches to revert it to the "old" behavior:
> first buildin chains, sorted by hooknum, than userdefined chains, sorted by name.

Why is the old behaviour better than the current?  Any scripts you have
should be smart enough to check for '^Chain ______' to determine chain.

Phil
