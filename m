From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 03/11] Split out the event cache
Date: Fri, 3 Nov 2006 14:31:17 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0611031430420.2974@tux.rsn.bth.se>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210913.061177411@wlug.westbo.se>
	<200611031247.kA3CleEl011459@toshiba.co.jp>
	<454B3B42.4050808@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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

On Fri, 3 Nov 2006, Patrick McHardy wrote:

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

Sorry about the build errors etc, I'll try more .config combinations in
the future.

/Martin
