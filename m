From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH/RFC 1/2] optimization updating timer in connection
	tracking
Date: Mon, 20 Sep 2004 14:56:45 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414ED38D.4020503@trash.net>
References: <414DFB56.1050503@eurodev.net> <414E5128.3040204@trash.net>
	<414ECC9C.8000105@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <414ECC9C.8000105@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> Patrick McHardy escribió:
>
>> We can't use mod_timer because it will re-add a timer that
>> already went off and dropped it's reference count to the conntrack.
>> mod_timer is equivalent to del_timer(); add_timer(); but we do
>> del_timer() && add_timer();
>
>
>
> thanks for the hint, in that case, is it worthy adding something like
>
> ----- from kernel/timer.c  ----
> 261         /*
> 262          * This is a common optimization triggered by the
> 263          * networking code - if the timer is re-modified
> 264          * to be the same thing then just return:
> 265          */
> 266         if (timer->expires == expires && timer_pending(timer))
> 267                 return 1;
> ----- end -------
>
> inside the write_lock section?


We already have something better in old pom:
netfilter/patch-o-matic/optimizations/ip_ct_refresh_optimization.patch:

--- linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c.orig       
Mon Jun  3 20:32:28 2002
+++ linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c    Mon Jun  
3 20:48:13 2002
@@ -1091,8 +1091,10 @@
        if (!is_confirmed(ct))
                ct->timeout.expires = extra_jiffies;
        else {
-               /* Need del_timer for race avoidance (may already be 
dying). */
-               if (del_timer(&ct->timeout)) {
+               /* Don't update timer for each packet, only if it's been >HZ
+                * ticks since last update.
+                * Need del_timer for race avoidance (may already be 
dying). */
+               if (abs(jiffies + extra_jiffies - ct->timeout.expires) 
 >= HZ && del_timer(&ct->timeout)) {
                        ct->timeout.expires = jiffies + extra_jiffies;
                        add_timer(&ct->timeout);
                }

It is also included in the ctnetlink patch to avoid excessive timeout 
notifications.

Regards
Patrick
