From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 0/19]: Netfilter Update
Date: Mon, 25 Oct 2004 02:48:31 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D5F.7080401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

the following 19 patches contain Yasuyuki's work to remove
skb_linearize from ip6_tables, Rusty's MASQUERADE changes
with Herbert's suggested change, ip_conntrack_stat fixes
and some minor cleanup. I'll check what is needed for 2.4
and send patches during the next week.

You can pull all changes from bk://212.42.230.204/nf-2.6

Regards
Patrick
