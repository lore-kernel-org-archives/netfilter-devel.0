From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ip_ct_refresh lock issue
Date: Sat, 28 Feb 2004 15:54:54 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402281547520.9609-100000@filer.marasystems.com>
References: <4040A334.3020808@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4040A334.3020808@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 28 Feb 2004, Pablo Neira wrote:

> I can't see the reason why in ip_ct_refresh the conntrack is locked to 
> modify an not confirmed conntrack timeout.

Good question.

But maybe there is some complication from NAT or related connections
requiring this locking?

If not the lock should probably be moved down to the is_confirmed case. If
the connections is not yet confirmed then the only reference should be
from this packet (not yet in the hashes) and there should never be any
concurrent accesses.

Regards
Henrik
