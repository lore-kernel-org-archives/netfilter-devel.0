From: Greg KH <gregkh@suse.de>
Subject: [patch 07/20] nfnetlink_log: fix possible NULL pointer dereference
Date: Fri, 9 Mar 2007 22:17:26 -0800
Message-ID: <20070310061726.GH31412@kroah.com>
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
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752691AbXCJGTo@vger.kernel.org>
Content-Disposition: inline; filename="nfnetlink_log-fix-possible-null-pointer-dereference.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

[NETFILTER]: nfnetlink_log: fix possible NULL pointer dereference

Eliminate possible NULL pointer dereference in nfulnl_recv_config().

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nfnetlink_log.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -867,6 +867,9 @@ nfulnl_recv_config(struct sock *ctnl, st
 			ret = -EINVAL;
 			break;
 		}
+
+		if (!inst)
+			goto out;
 	} else {
 		if (!inst) {
 			UDEBUG("no config command, and no instance for "
@@ -920,6 +923,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 
 out_put:
 	instance_put(inst);
+out:
 	return ret;
 }
 

-- 
