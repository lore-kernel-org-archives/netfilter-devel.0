From: Greg KH <gregkh@suse.de>
Subject: [patch 12/20] nfnetlink_log: fix reference counting
Date: Fri, 9 Mar 2007 22:18:03 -0800
Message-ID: <20070310061803.GM31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
	Michal Miroslaw <mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751049AbXCJGUZ@vger.kernel.org>
Content-Disposition: inline; filename="nfnetlink_log-fix-reference-counting.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

[NETFILTER]: nfnetlink_log: fix reference counting

Fix reference counting (memory leak) problem in __nfulnl_send() and callers
related to packet queueing.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nfnetlink_log.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -220,7 +220,8 @@ _instance_destroy2(struct nfulnl_instanc
 		/* timer "holds" one reference (we have one more) */
 		if (timer_pending(&inst->timer)) {
 			del_timer(&inst->timer);
-			instance_put(inst);
+
+instance_put(inst);
 		}
 		if (inst->qlen)
 			__nfulnl_send(inst);

-- 
