From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter Connection Tracking Race Condition in Kernel 2.4.x
Date: Wed, 26 Jul 2006 05:56:04 +0200
Message-ID: <44C6E7D4.5020505@trash.net>
References: <44C56653.10901@nominum.com> <44C56ECC.3020107@trash.net>
	<20060726005415.GA18817@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Bob Halley <Bob.Halley@nominum.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060726005415.GA18817@linuxace.com>
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

Phil Oester wrote:
> On Tue, Jul 25, 2006 at 03:07:24AM +0200, Patrick McHardy wrote:
> 
>>- change conntrack to always put connections in the hash immediately
>>  and remove them again if the connection is dropped before beeing
>>  confirmed.
> 
> 
> This could in theory be implemented via an IPS_UNCONFIRMED_BIT (ignoring
> the sure to be complicated implementation details).  But would there be
> any concern about a DOS against the hash if unconfirmed connections
> were allowed to enter?


There isn't really a difference to keeping them in the unconfirmed
list besides better scalability. The same properties for unconfirmed
entries hold here, usually there should be very few (max 2 per CPU
without preemption), except if queueing is involved. I don't think
there is an increased risk of DOS by using the conntrack hash vs.
using a seperate hash, but with the conntrack hash we can do it all
in one lookup and use the existing eviction mechanism.
