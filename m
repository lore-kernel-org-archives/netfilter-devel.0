From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH][CTNETLINK] Include the id in conntrack netlink events.
Date: Tue, 14 Aug 2007 17:03:15 +1000
Message-ID: <46C153B3.1020104@snapgear.com>
References: <46C138AC.1000106@snapgear.com>
	<46C1451C.5040107@trash.net>	<46C14B05.2000200@snapgear.com>
	<46C14CDE.5030803@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46C14CDE.5030803@trash.net>
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

Patrick McHardy wrote:
> True, but its quite a waste in the kernel as well when considering
> that almost nobody needs this. I was thinking about derriving a
> unique ID just for userspace from the conntrack address (in memory).
> Its not unique over time, just as tuples aren't, but when combined
> with the tuples it should only clash very rarely, and you'll always
> get a DESTROY + NEW event before a clash. Would that work for you?

Yes, that should be fine.  I've used that previously with an old
linux 2.4 conntrack events patch.
