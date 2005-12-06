From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [RESEND 2] [1/2] OSF: fix 2.4 compilation.
Date: Tue, 6 Dec 2005 16:51:58 +0300
Message-ID: <20051206135158.GA27686@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, PatriK McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Bug found by Aleksey Barabanov <alekseybb mail.ru>.
Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- net/ipv4/netfilter/ipt_osf.c.orig	2005-11-26 15:29:33.000000000 +0300
+++ net/ipv4/netfilter/tmp/ipt_osf.c	2005-11-26 15:29:05.000000000 +0300
@@ -183,11 +183,11 @@
 		_optp = optp = (char *)(tcp+1);
 		optsize = tcp->doff*4 - sizeof(struct tcphdr);
 
-		if (optsize > sizeof(opts))
+		if (optsize > MAX_IPOPTLEN)
 		{
-			log("%s: BUG: too big options size: optsize=%lu, max=%zu.\n",
-					__func__, optsize, sizeof(opts));
-			optsize = sizeof(opts);
+			log("%s: BUG: too big options size: optsize=%lu, max=%u.\n",
+					__func__, optsize, MAX_IPOPTLEN);
+			optsize = MAX_IPOPTLEN;
 		}
 	}
 

-- 
	Evgeniy Polyakov
