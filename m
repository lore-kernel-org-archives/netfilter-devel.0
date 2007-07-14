From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH IPTABLES 0/43]: Unification of ip[6]tables matches/targets #2
Date: Sun, 15 Jul 2007 02:21:23 +0900 (JST)
Message-ID: <200707141721.l6EHLOHo022296@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


This patchset is for unifying codes in matches/targets of ip[6]tables.
The change from the last patchset is that all declarations in
iptables_common.h are moved into xtables.h

I also attach patches to unify libip[6]t_NOTRACK and libip[6]t_multiport
respectively. The former is easiest case of unification, and later is
most complicated case. The patches for other matches/targets are also
attached, but I've not completed unification for all of matches/targets
yet.

-- Yasuyuki Kozakai
