From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 05/17]: recent match: replace by rewritten version
Date: Tue, 30 May 2006 15:16:51 +0200
Message-ID: <447C45C3.5000502@trash.net>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
	<20060529223413.24834.97896.sendpatchset@localhost.localdomain>
	<20060530131150.GV8588@kenobi.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20060530131150.GV8588@kenobi.snowman.net>
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

Stephen Frost wrote:
> * Patrick McHardy (kaber@trash.net) wrote:
> 
>>[NETFILTER]: recent match: replace by rewritten version
> 
> 
> I havn't had a chance to check yet, but was something done about the
> last round of issues I pointed out?  Specifically, concerns that entries
> in the table which are never updated will not end up in the list to be
> candidates for deletion due to the eviction policy?  I don't think it'd
> be a good plan to move to this till that's fixed (it's not hard to fix,
> either).

Already fixed.
