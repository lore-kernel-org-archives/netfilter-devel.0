From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: "local_bh_disable"
	[net/ipv4/netfilter/ip_conntrack_pptp.ko]undefined!
Date: Mon, 16 Jan 2006 13:04:41 +0100
Message-ID: <BAY103-F39CECF9E33582648543630B21B0@phx.gbl>
References: <BAY103-F32DBAD0DD8DF026ECDDEE0B2270@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <BAY103-F32DBAD0DD8DF026ECDDEE0B2270@phx.gbl>
To: davem@davemloft.net
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

Me again.
This patch resolves this problem (tested on 2.6.15-git12):

*** linux-2.6.15/net/ipv4/netfilter/ip_conntrack_proto_gre.c    2006-01-16 
12:50:26.000000000 +0100
--- linux-2.6.15-git12/net/ipv4/netfilter/ip_conntrack_proto_gre.c      
2006-01-16 12:20:25.000000000 +0100
***************
*** 32,37 ****
--- 32,38 ----
  #include <linux/in.h>
  #include <linux/list.h>
  #include <linux/seq_file.h>
+ #include <linux/interrupt.h>

  static DEFINE_RWLOCK(ip_ct_gre_lock);
  #define ASSERT_READ_LOCK(x)

Marco Berizzi wrote:

>David S. Miller wrote:
>
>>From: "Marco Berizzi" <pupilla@hotmail.com>
>>Date: Wed, 11 Jan 2006 10:49:12 +0100
>>
>> > I'm compiling pptp conntrack/nat as module and I getting this warning:
>>
>>This should fix it:
>>
>>diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
>>index 799be67..7db4df8 100644
>>--- a/include/linux/spinlock.h
>>+++ b/include/linux/spinlock.h
>>@@ -53,6 +53,7 @@
>>  #include <linux/thread_info.h>
>>  #include <linux/kernel.h>
>>  #include <linux/stringify.h>
>>+#include <linux/interrupt.h>
>>
>>  #include <asm/system.h>
