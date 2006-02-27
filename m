From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/5] netfilter updates
Date: Mon, 27 Feb 2006 03:09:59 +0100
Message-ID: <44025F77.9090202@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
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

Hi,

This is the reincarnation of several patches that I have reworked
following your feedback. Hope that they are fine.

[PATCH 1/5] [CTNETLINK] Fix expectation mask dumping
[PATCH 2/5] [NFQUEUE_NETLINK] Fix nfnetlink message size
[PATCH 3/5] [CONNTRACK] cleanup the conntrack ID initialization
[PATCH 4/5] [XT_TABLES] Set the protocol family in x_tables targets/matches
[PATCH 5/5] [NF_CONNTRACK] load on demand layer 3 protocol handlers

cheers,
Pablo

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
