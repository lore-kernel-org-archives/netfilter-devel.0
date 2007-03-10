From: Greg KH <gregkh@suse.de>
Subject: [patch 09/20] nf_conntrack: fix incorrect classification of IPv6
	fragments as ESTABLISHED
Date: Fri, 9 Mar 2007 22:17:41 -0800
Message-ID: <20070310061741.GJ31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
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
	filename="nf_conntrack-fix-incorrect-classification-of-ipv6-fragments-as-established.patch"
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
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: nf_conntrack: fix incorrect classification of IPv6 fragments as ESTABLISHED

The individual fragments of a packet reassembled by conntrack have the
conntrack reference from the reassembled packet attached, but nfctinfo
is not copied. This leaves it initialized to 0, which unfortunately is
the value of IP_CT_ESTABLISHED.

The result is that all IPv6 fragments are tracked as ESTABLISHED,
allowing them to bypass a usual ruleset which accepts ESTABLISHED
packets early.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -257,6 +257,7 @@ static unsigned int ipv6_conntrack_in(un
 		}
 		nf_conntrack_get(reasm->nfct);
 		(*pskb)->nfct = reasm->nfct;
+		(*pskb)->nfctinfo = reasm->nfctinfo;
 		return NF_ACCEPT;
 	}
 

-- 
