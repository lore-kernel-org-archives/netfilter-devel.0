From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt->xt
Date: Mon, 15 Jan 2007 17:36:04 +0100
Message-ID: <45ABAD74.7010808@trash.net>
References: <20070114192011.GA6270@clipper.ens.fr>
	<Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
	<45AB3DCA.9020204@trash.net>
	<Pine.LNX.4.61.0701151109540.32479@yvahk01.tjqt.qr>
	<45AB54E5.6060103@trash.net>
	<Pine.LNX.4.61.0701151526300.13639@yvahk01.tjqt.qr>
	<45AB94F7.6040806@trash.net>
	<Pine.LNX.4.61.0701151725490.23841@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701151725490.23841@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> 
>>>Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_LOG.c
>>>===================================================================
>>>--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_LOG.c
>>>+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_LOG.c
>>>@@ -20,12 +20,12 @@
>>> #include <net/route.h>
>>> 
>>> #include <linux/netfilter.h>
>>>-#include <linux/netfilter_ipv4/ip_tables.h>
>>>+#include <linux/netfilter/x_tables.h>
>>> #include <linux/netfilter_ipv4/ipt_LOG.h>
>>
>>Please keep the _ipv4 entries next to each other.
> 
> 
> How do you mean? It looks like this atm:
> 
> #include <linux/netfilter.h>
> #include <linux/netfilter/x_tables.h>
> #include <linux/netfilter_ipv4/ipt_LOG.h>


Right, I misread the patch.
