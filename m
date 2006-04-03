From: Patrick McHardy <kaber@trash.net>
Subject: Patch-o-matic cleanup
Date: Mon, 03 Apr 2006 20:12:58 +0200
Message-ID: <443165AA.4030509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Following (quite late) the decision taken at the netfilter workshop to
clean up the pomng repository by removing old patches and moving some
patches out of the netfilter repository, I've started by removing the
obsolete ipsec* patches and the policy match. Both have been merged
and were pretty outdated.

If noone can name good reasons against it, I will also remove the
following patches in a few days:

- NETLINK: obsolete
- NETMAP: in mainline for a long time
- TRACE: don't recall the reason, but its on my list :)
- comment: in mainline
- conntrack_locking: seriously outdated, if someone wants to resurrect
  this patch he can use the history
- dropped_table: also don't recall the reason
- goto: in mainline
- ipq_vmark: obsoleted by nfnetlink_queue
- mport: mainline multiport supports all of its features
- netfilter-docbook: outdated
- owner-socketlookup: unfixable broken
- pool: obsoleted by ipset
- pptp-conntrack-nat: in mainline now, patches are missing critical
  fixes
- unclean: bad idea
