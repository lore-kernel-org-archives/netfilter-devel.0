From: Patrick McHardy <kaber@trash.net>
Subject: nth, random and fuzzy match
Date: Thu, 06 Apr 2006 19:53:30 +0200
Message-ID: <4435559A.60904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Also following the decisions from the netfilter workshop,
I've started merging nth and random into a new "statistic"
match. I won't merge fuzzy since it seems to obscure and
complex and I don't see what it offers beyond nth + random.

The current nth match optionally uses shared state for the
counters (which as we know isn't pretty with the current
iptables userspace interface) and has a compile-time limit
on the number of shared counters. I don't see the need for
this shared state, I think everything expressable today
should also be expressable using just per-match state.

So my questions to the nth users: is anyone using the nth
match in a way that can't be done by just matching on every
nth packet with an optional starting point?
