From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Multiple Address specification or match
Date: Thu, 30 Sep 2004 13:42:33 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409301341530.29461@filer.marasystems.com>
References: <003301c4a6cc$069e3fb0$2201010a@bluereef.local>
	<1096538091.4406.12.camel@porky>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1096538091.4406.12.camel@porky>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 30 Sep 2004, Eric Leblond wrote:

> iptables/netfilter has to be efficient, rules generation script has to
> be elegant. Having 3 rules is as efficient as your masked "or" rules if
> it was coded and 3 separate rules are more simple than your global one
> so in a way this is more elegant.

For hipac this is true, but not really when using iptables.

Regards
Henrik
