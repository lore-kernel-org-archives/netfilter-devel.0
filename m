From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] entry_data
Date: Mon, 19 Jun 2006 02:15:10 +0200
Message-ID: <4495EC8E.6030006@netfilter.org>
References: <200606050029.08602.max@nucleus.it>
	<200606121445.42157.max@nucleus.it>
	<448ED795.3010509@netfilter.org>
	<200606132256.10384.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606132256.10384.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Tuesday 13 June 2006 5:19 pm, Pablo Neira Ayuso wrote:
> 
> 
>>> static int
>>> match(const struct sk_buff *skb, const struct net_device *in,
>>>-      const struct net_device *out, const void *matchinfo, int offset,
>>>-      unsigned int protoff, int *hotdrop)
>>>+      const struct net_device *out, const struct xt_match *match,
>>>+      const void *matchinfo, int offset,
>>>+      unsigned int protoff, int *hotdrop, void *entry_data)
>>
>>Hm, then you must have a patch to modify the interface match()?
> 
> 
> Of course. I sent a patch in the previous message:
> https://lists.netfilter.org/pipermail/netfilter-devel/2006-June/024656.html
> 
> The patches are available here:
> https://lists.netfilter.org/pipermail/netfilter-devel/attachments/20060605/94b0d808/2.6.17-rc5-entry_data_core-0001.bin
> https://lists.netfilter.org/pipermail/netfilter-devel/attachments/20060605/94b0d808/2.6.17-rc5-entry_data_matches-0001.bin

Unfortunately, your patch breaks old iptables binaries, so it can't 
guarantee backward compatibility :(

pablo@Decadence:~$ head -10 2.6.17-rc5-entry_data_core-0001.bin
diff -Nru linux-2.6.17-rc5/include/linux/netfilter/x_tables.h 
linux-2.6.17-rc5.entry_data_core/include/linux/netfilter/x_tables.h
--- linux-2.6.17-rc5/include/linux/netfilter/x_tables.h 2006-06-04 
21:30:58.000000000 +0200
+++ linux-2.6.17-rc5.entry_data_core/include/linux/netfilter/x_tables.h 
2006-06-04 21:34:03.000000000 +0200
@@ -20,6 +20,7 @@

                         /* Used inside the kernel */
                         struct xt_match *match;
+                       void *entry_data;
                 } kernel;

You can't modify the layout of xt_entry_[match|target] since this 
structure is shared between userspace (iptables) and kernel space.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
