From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
Subject: [2.6.14] ipt_TARPIT vs sysctl_ip_default_ttl.
Date: Wed, 2 Nov 2005 17:54:41 +0100
Message-ID: <200511021754.41694.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965134AbVKBQys@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

The ipt_TARPIT module uses sysctl_ip_default_ttl
variable but kernel doesn't export this symbol.

ipt_TARPIT.c:
(...)
        /* Adjust IP TTL */
#ifdef CONFIG_SYSCTL
        nskb->nh.iph->ttl = sysctl_ip_default_ttl;
#else
        nskb->nh.iph->ttl = IPDEFTTL;
#endif
(...)

Finally we get undefined symbol in TARPIT module.

--- linux-2.6.14/net/ipv4/ip_output.c.orig
+++ linux-2.6.14/net/ipv4/ip_output.c
@@ -1329,3 +1329,4 @@
 EXPORT_SYMBOL(ip_generic_getfrag);
 EXPORT_SYMBOL(ip_queue_xmit);
 EXPORT_SYMBOL(ip_send_check);
+EXPORT_SYMBOL(sysctl_ip_default_ttl);

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke
