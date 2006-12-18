From: Alejandro David Galera Ruiz <alejandro.galera@gmail.com>
Subject: Re: [PATCH] Re: Time match in mangle/POSTROUTING?
Date: Mon, 18 Dec 2006 17:28:13 +0100
Message-ID: <1166459293.27555.35.camel@palocortado>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: brad@info-link.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I'm trying to use netfilter with classify and temporal filters. Due to I
realised that POSTROUTING wasn't supported in mangle table, I decided to
patch ipt_time module following Brad Fisher's PATCH.

I've tried to update this patch for kernel 2.6.17 and the lastest
version of patch-o-matic (20061213).
It's my first contribution to this project, I hope to be a little bit
useful for your great project.

Using: 
Patch-o-matic 20061213

Modifications:

* Time modification (the same from Brad Fisher
http://lists.netfilter.org/pipermail/netfilter-devel/2003-December/013367.html) 

> >Brad Fisher wrote:
> >
> >* I don't see any reason why the above approach 
> >  wouldn't work in any chain, so I
> >  removed the check from checkentry.

* I think it could be more deffensive and flexible in the future if we
add NF_IP_POST_ROUTING checking to checkentry function instead of quit
any verification.
* System message according to let POST_ROUTING.
* System warning message specifying invalid argument is due to time
higher than 24h (it also has been taken from Brad Fisher's patch)

All your suggestions, indications or tests will be wellcome
Thanks in advance

--- ipt_time.c.old      2006-12-14 19:21:10.000000000 +0100
+++ ipt_time.c  2006-12-14 19:12:20.000000000 +0100
@@ -79,8 +79,15 @@
 
        /* ... check the time now */
        packet_time = (currenttime.tm_hour * 60) + currenttime.tm_min;
-       if ((packet_time < info->time_start) || (packet_time >
info->time_stop))
-               return 0;
+       if (info->time_start <= info->time_stop) {
+               /* normal order: start <= stop */
+               if ((packet_time < info->time_start) || (packet_time >
info->time_stop))
+                        return 0;
+        } else {
+               /* reversed order: stop < start */
+                if ((packet_time < info->time_start) && (packet_time >
info->time_stop))
+                        return 0;
+        }
 
        /* here we match ! */
        return 1;
@@ -104,9 +111,9 @@
 
        /* First, check that we are in the correct hooks */
        if (hook_mask
-            & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) | (1
<< NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT)))
+            & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) | (1
<< NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING)))
        {
-               printk("ipt_time: error, only valid for PRE_ROUTING,
LOCAL_IN, FORWARD and OUTPUT)\n");
+               printk("ipt_time: error, only valid for PRE_ROUTING,
POST_ROUTING, LOCAL_IN, FORWARD and OUTPUT)\n");
                return 0;
        }
 
@@ -120,7 +127,7 @@
        if ((info->time_start > 1439) ||        /* 23*60+59 = 1439*/
            (info->time_stop  > 1439))
        {
-               printk(KERN_WARNING "ipt_time: invalid argument\n");
+               printk(KERN_WARNING "ipt_time: invalid argument: start
or stop time greater than 24h\n");
                return 0;
        }
