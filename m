From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [RFC PATCH IPTABLES 0/12]: matches/targets unification
Date: Thu, 30 Nov 2006 18:43:41 +0900 (JST)
Message-ID: <200611300943.kAU9hhUn013373@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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


Hi, all,

This patch series enables to unify matches/targets of ip[6]tables.

I've changed the only parts to unify register_{match,target} and
moves duplicated functions to a file. Unfortunately, I had to change some
arguments of the traditional APIs for them, but they are to avoid
warning on compilation.

It might not be good time to submit this because of recent patch rush
and it's just before next release of iptables, so it's just RFC this time.

-- Yasuyuki Kozakai
