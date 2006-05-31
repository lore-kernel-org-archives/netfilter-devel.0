From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 05/17]: recent match: replace by rewritten version
Date: Wed, 31 May 2006 02:48:03 +0200
Message-ID: <447CE7C3.7000400@trash.net>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
	<20060529223413.24834.97896.sendpatchset@localhost.localdomain>
	<20060530131150.GV8588@kenobi.snowman.net>
	<447C45C3.5000502@trash.net>
	<20060530181018.GW8588@kenobi.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20060530181018.GW8588@kenobi.snowman.net>
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
> Great, thanks.  I've now reviewed the version in DaveM's net-2.6.18 git
> tree and it looks good to me.  I'll try and do some real-world testing
> on it this weekend.  I'm very curious if these changes will allow for
> larger lists than was previously possible.


Thanks Stephen, I appreciate your help getting rid of the problem.
It should perform a lot better with large lists, the closed hash
with linear probing looked horribly inefficient.
