From: Greg KH <gregkh@suse.de>
Subject: [patch 08/20] ip6_route_me_harder should take into account mark
Date: Fri, 9 Mar 2007 22:17:34 -0800
Message-ID: <20070310061734.GI31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	netfilter-devel@lists.netfilter.org, Justin Forbes <jmforbes@linuxtx.org>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>, davem@davemloft.net,
	Randy Dunlap <rdunlap@xenotime.net>, Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	Patrick McHardy <kaber@trash.net>, alan@lxorguk.ukuu.org.uk
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline;
	filename="ip6_route_me_harder-should-take-into-account-mark.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
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

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

[NETFILTER]: ip6_route_me_harder should take into account mark

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/netfilter.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -15,6 +15,7 @@ int ip6_route_me_harder(struct sk_buff *
 	struct dst_entry *dst;
 	struct flowi fl = {
 		.oif = skb->sk ? skb->sk->sk_bound_dev_if : 0,
+		.mark = skb->mark,
 		.nl_u =
 		{ .ip6_u =
 		  { .daddr = iph->daddr,

-- 
