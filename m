From: Greg KH <gregkh@suse.de>
Subject: [patch 04/20] nfnetlink_log: fix reference leak
Date: Fri, 9 Mar 2007 22:17:01 -0800
Message-ID: <20070310061701.GE31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	netfilter-devel@lists.netfilter.org, Justin Forbes <jmforbes@linuxtx.org>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>, davem@davemloft.net,
	Randy Dunlap <rdunlap@xenotime.net>, Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
	Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
	torvalds@linux-foundation.org, Patrick McHardy <kaber@trash.net>,
	alan@lxorguk.ukuu.org.uk
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline; filename="nfnetlink_log-fix-reference-leak.patch"
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

[NETFILTER]: nfnetlink_log: fix reference leak

Stop reference leaking in nfulnl_log_packet(). If we start a timer we
are already taking another reference.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/netfilter/nfnetlink_log.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -720,15 +720,16 @@ nfulnl_log_packet(unsigned int pf,
 		inst->timer.expires = jiffies + (inst->flushtimeout*HZ/100);
 		add_timer(&inst->timer);
 	}
-	spin_unlock_bh(&inst->lock);
 
+unlock_and_release:
+	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 	return;
 
 alloc_failure:
-	spin_unlock_bh(&inst->lock);
-	instance_put(inst);
 	UDEBUG("error allocating skb\n");
 	/* FIXME: statistics */
+	goto unlock_and_release;
 }
 
 static int

-- 
