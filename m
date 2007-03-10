From: Greg KH <gregkh@suse.de>
Subject: [patch 05/20] nfnetlink_log: fix use after free
Date: Fri, 9 Mar 2007 22:17:11 -0800
Message-ID: <20070310061711.GF31412@kroah.com>
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
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752228AbXCJGSx@vger.kernel.org>
Content-Disposition: inline; filename="nfnetlink_log-fix-use-after-free.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: nfnetlink_log: fix use after free

Paranoia: instance_put() might have freed the inst pointer when we
spin_unlock_bh().

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -397,8 +397,8 @@ static void nfulnl_timer(unsigned long d
 	if (timer_pending(&inst->timer))	/* is it always true or false here? */
 		del_timer(&inst->timer);
 	__nfulnl_send(inst);
-	instance_put(inst);
 	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 }
 
 /* This is an inline function, we don't really care about a long

-- 
