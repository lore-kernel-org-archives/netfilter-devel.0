From: wanghtb@legend.com.cn
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Thu, 1 Apr 2004 11:10:53 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OF4647B020.55BDAE17-ON48256E69.0010A57F@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

And I think the compiling direction 
 "#ifndef CONFIG_IP_NF_NAT_LOCAL"
maybe not need, since in any situation, we should not 
use ip_conntrack_reply() to change a confirmed ct, which 
will make ct's hash value changed,  and make LIST_DELETE() dump a 
warning: this entry is not in the correct bucket list :-)

>  I think the patch is buggy. The check should be
>
> if (!(info->initialized & (1 << maniptype))
>    && !(ct->status & IPS_CONFIRMED))
>
>instead of
>
>  if (!(info->initialized & (1 << maniptype))
>      && ct->status & IPS_CONFIRMED)
>
>  Fixed patch attached. I've tested it on my UML testbed with stock
> 2.4.24, and seems to solve the problem.
>
> -- 
> Regards,
>   Krisztian KOVACS
>
>--=-+pqSK1ygFZXfde1OZN5T
>Content-Disposition: attachment; filename=renat_confirmed.patch
>Content-Type: text/plain; name=renat_confirmed.patch; charset=iso-8859-2
>Content-Transfer-Encoding: 7bit
>
>--- ip_nat_standalone.c.orig            Fri Nov 28 19:26:21 2003
>+++ ip_nat_standalone.c                 Thu Mar 25 16:43:29 2004
>@@ -114,7 +114,16 @@
>                                WRITE_LOCK(&ip_nat_lock);
>                                /* Seen it before?  This can happen for 
loopback, retrans,
>                                   or local packets.. */
>-                               if (!(info->initialized & (1 << 
maniptype))) {
>+                               if (!(info->initialized & (1 << 
maniptype))
>+#ifndef CONFIG_IP_NF_NAT_LOCAL
>+                                   /* If this session has already been 
confirmed we must not
>+                                    * touch it again even if there is no 
mapping set up.
>+                                    * Can only happen on local->local 
traffic with
>+                                    * CONFIG_IP_NF_NAT_LOCAL disabled.
>+                                    */
>+                                   && !(ct->status & IPS_CONFIRMED)
>+#endif
>+                                   ) {
>                                                unsigned int ret;
> 
>                                                if (ct->master
>
>--=-+pqSK1ygFZXfde1OZN5T--
