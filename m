From: Damon Gray <dgray@internap.com>
Subject: why spin_lock_bh() in match routine?
Date: Thu, 30 Jun 2005 13:49:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0506301333510.2222@dgray-test.acs.internap.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


If I'm not mistaken, and I possibly am, the match section of a netfilter 
module is run in softirq context, and the same softirq (not tasklet) can 
run on a *different* CPU but not the same CPU twice. So why is it being 
suggested here that we need to disable bottom halves for match targets.
Seems to me you will be safe with spin_lock() in match() and possibly need 
spin_lock_bh() in at least destroy() and maybe in checkentry(). Am I 
missing some?

-Damon-
