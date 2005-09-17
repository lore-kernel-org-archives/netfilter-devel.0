From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sat, 17 Sep 2005 18:28:44 +0200
Message-ID: <432C443C.5010101@trash.net>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
	<4329F94E.4060107@trash.net>
	<20050916091548.GO5034@sunbeam.de.gnumonks.org>
	<20050916.154556.116608678.davem@davemloft.net>
	<20050916225131.GS8413@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050916225131.GS8413@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Fri, Sep 16, 2005 at 03:45:56PM -0700, David S. Miller wrote:
> 
>>Why don't you guys work together to integrate all of the fixes, and
>>then resubmit PPTP as one changeset with all the bug fixes already
>>applied?  I think that would work best and prevent changeset bloat.
> 
> yes, ideally that would be the way for it to happen.  Unfortuantely the
> PPTP helper has been around for many years (patch-o-matic-ng, latest
> version in my git tree, ...) and it apparently still didn't receive the
> kind of review it required.

The thing with patch-o-matic is that it includes tons of crap and you
never know if it includes the latest version of something, so I focus
on things submitted to the kernel. So maybe a heads-up one or two days
before submission would help. Anyway, I was just writing a mail
including some more suggestions when Dave applied the patch. I'll
go over the patch again later and send you my remaining suggestions.
