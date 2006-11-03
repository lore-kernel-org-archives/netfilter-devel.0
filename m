From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/11] Split out the event cache
Date: Fri, 03 Nov 2006 13:51:14 +0100
Message-ID: <454B3B42.4050808@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>	<20061101210913.061177411@wlug.westbo.se>
	<200611031247.kA3CleEl011459@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611031247.kA3CleEl011459@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
>>+#ifdef CONFIG_NF_CONNTRACK_EVENTS
>>+#include <linux/notifier.h>
>>+#include <linux/interrupt.h>
>>+#include <net/netfilter/nf_conntrack_expect.h>
> 
> 
> This should be out of CONFIG_NF_CONNTRACK_EVENTS, to avoid build error at

Thanks, I'll fix it up after doing a few more build tests.
