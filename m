From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 03/11] Split out the event cache
Date: Fri, 03 Nov 2006 21:57:06 +0900 (JST)
Message-ID: <200611031257.kA3Cv8VQ012199@toshiba.co.jp>
References: <20061101210913.061177411@wlug.westbo.se>
	<200611031247.kA3CleEl011459@toshiba.co.jp>
	<454B3B42.4050808@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <454B3B42.4050808@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 03 Nov 2006 13:51:14 +0100

> Yasuyuki KOZAKAI wrote:
> >>+#ifdef CONFIG_NF_CONNTRACK_EVENTS
> >>+#include <linux/notifier.h>
> >>+#include <linux/interrupt.h>
> >>+#include <net/netfilter/nf_conntrack_expect.h>
> > 
> > 
> > This should be out of CONFIG_NF_CONNTRACK_EVENTS, to avoid build error at
> 
> Thanks, I'll fix it up after doing a few more build tests.

You will find missing "#include <net/netfilter/nf_conntrack_ecache.h>"
in xt_CONNMARK.c. This is last error I found today.

-- Yasuyuki Kozakai
