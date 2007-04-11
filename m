From: Greg KH <gregkh@suse.de>
Subject: [patch 13/31] NETFILTER: ipt_CLUSTERIP: fix oops in checkentry
	function
Date: Wed, 11 Apr 2007 15:51:59 -0700
Message-ID: <20070411225159.GN24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
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
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jaroslav Kysela <perex@suse.cz>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161373AbXDKWzG@vger.kernel.org>
Content-Disposition: inline; filename="netfilter-ipt_clusterip-fix-oops-in-checkentry-function.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: ipt_CLUSTERIP: fix oops in checkentry function

The clusterip_config_find_get() already increases entries reference
counter, so there is no reason to do it twice in checkentry() callback.

This causes the config to be freed before it is removed from the list,
resulting in a crash when adding the next rule.

Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -409,12 +409,10 @@ checkentry(const char *tablename,
 				       "has invalid config pointer!\n");
 				return 0;
 			}
-			clusterip_config_entry_get(cipinfo->config);
 		} else {
 			/* Case B: This is a new rule referring to an existing
 			 * clusterip config. */
 			cipinfo->config = config;
-			clusterip_config_entry_get(cipinfo->config);
 		}
 	} else {
 		/* Case C: This is a completely new clusterip config */

-- 
