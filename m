From: Jan Srzednicki <w@303.krakow.pl>
Subject: ipt_CLASSIFY module
Date: Mon, 21 Apr 2003 16:07:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030421140746.GQ89044@spitfire.303.krakow.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kaber@trash.net
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello there,

I've just checked: -j CLASSIFY works well also in mangle table, chain
FORWARD (with HTB, if that matters). So I made a little fix for that:

--- ipt_CLASSIFY.c.old  Mon Apr 21 16:02:08 2003
+++ ipt_CLASSIFY.c      Mon Apr 21 15:58:12 2003
@@ -39,8 +39,9 @@
                return 0;
        }
        
-       if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
-               printk(KERN_ERR "CLASSIFY: only valid in POST_ROUTING.\n");
+       if (hook_mask & ~(1 << NF_IP_POST_ROUTING) && 
+           hook_mask & ~(1 << NF_IP_FORWARD) ) {
+               printk(KERN_ERR "CLASSIFY: only valid in POSTROUTING or FORWARD.\n");
                return 0;
        }

greets,
-- 
  -- wrzask --= v =-- Winfried --===-- GG# 3838383 ---
-- w@dream.vg --- w@303.krakow.pl --===-- http://violent.dream.vg/ ---
--=< Ride the wild wind - push the envelope, don't sit on the fence, ---
  -- Ride the wild wind - live life on the razor's edge! >=-- Queen --
