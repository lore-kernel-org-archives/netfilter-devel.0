From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_CLASSIFY module
Date: Mon, 21 Apr 2003 16:23:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA3FEE6.3010601@trash.net>
References: <20030421140746.GQ89044@spitfire.303.krakow.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jan Srzednicki <w@303.krakow.pl>
In-Reply-To: <20030421140746.GQ89044@spitfire.303.krakow.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jan,
thanks for your patch ;)

My first version worked in FORWARD chain, too. The problem is
LOCAL_OUT doesn't work because "skb->priority = sk->priority"
line in ip_queue_xmit2. It was discussed to move it to ip_queue_xmit
some time ago because Bert Huber made a similar patch but the
networking maintainers didn't like it. So for consistency i decided
to restrict usage to POST_ROUTING only. Harald said he would have
no problem with such a change because he doesn't plan to submit
the CLASSIFY target in the near future anyways, so maybe an
incremental patch which enables use in FORWARD and OUTPUT
chain would be ok ..

Best regards,
Patrick

Jan Srzednicki wrote:

>Hello there,
>
>I've just checked: -j CLASSIFY works well also in mangle table, chain
>FORWARD (with HTB, if that matters). So I made a little fix for that:
>
>--- ipt_CLASSIFY.c.old  Mon Apr 21 16:02:08 2003
>+++ ipt_CLASSIFY.c      Mon Apr 21 15:58:12 2003
>@@ -39,8 +39,9 @@
>                return 0;
>        }
>        
>-       if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
>-               printk(KERN_ERR "CLASSIFY: only valid in POST_ROUTING.\n");
>+       if (hook_mask & ~(1 << NF_IP_POST_ROUTING) && 
>+           hook_mask & ~(1 << NF_IP_FORWARD) ) {
>+               printk(KERN_ERR "CLASSIFY: only valid in POSTROUTING or FORWARD.\n");
>                return 0;
>        }
>
>greets,
>  
>
