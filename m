From: Patrick Schaaf <bof@bof.de>
Subject: Re: About matching
Date: Thu, 7 Apr 2005 08:43:23 +0200
Message-ID: <20050407064323.GE20287@oknodo.bof.de>
References: <20050407113830.02B0.LARK@linux.net.cn>
	<20050407054302.GC20287@oknodo.bof.de>
	<20050407135853.02BA.LARK@linux.net.cn>
	<20050407063547.GD20287@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20050407063547.GD20287@oknodo.bof.de>
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

Hmm, regarding --previous... Do we have two bits spare in the
general rule structure, which could indicate 'match just like
the previous match did', and 'match exactly if the previous
match did NOT match'?

It we do have such bits spare, a general --previous-matched
and --previous-failed syntax might be easier than a new match
with signature change or percpu variables: all decision logic
stays properly localized in the table scanning main loop.

BTW, it just occurred to be that --previous-failed, a logical
consequence of the --previous idea :), is a nice thing to
have by itself: it permits proper if/then/else semantics
for nonterminating targets!

iptables -A xxx -m this -m that -j LOG --log-prefix "thisandthat: "
iptables -A xxx --previous-failed -j LOG --log-prefix "NOT-thisandthat: "

best regards
  Patrick
