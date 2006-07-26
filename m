From: Phil Oester <kernel@linuxace.com>
Subject: Re: Netfilter Connection Tracking Race Condition in Kernel 2.4.x
Date: Tue, 25 Jul 2006 17:54:15 -0700
Message-ID: <20060726005415.GA18817@linuxace.com>
References: <44C56653.10901@nominum.com> <44C56ECC.3020107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bob Halley <Bob.Halley@nominum.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44C56ECC.3020107@trash.net>
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

On Tue, Jul 25, 2006 at 03:07:24AM +0200, Patrick McHardy wrote:
> - change conntrack to always put connections in the hash immediately
>   and remove them again if the connection is dropped before beeing
>   confirmed.

This could in theory be implemented via an IPS_UNCONFIRMED_BIT (ignoring
the sure to be complicated implementation details).  But would there be
any concern about a DOS against the hash if unconfirmed connections
were allowed to enter?

Phil
