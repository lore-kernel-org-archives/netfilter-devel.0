From: dann frazier <dannf@dannf.org>
Subject: [PATCH] unaligned accesses in arp_tables.c
Date: Sun, 29 Feb 2004 17:11:56 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040301001156.GA18454@dannf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: awilliam@fc.hp.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

On ia64, I was getting a ton of unaligned accesses from this bit of code in
ipv4/netfilter/arp_tables.c:

        /* Look for ifname matches; this should unroll nicely. */
        for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
                ret |= (((const unsigned long *)indev)[i]
                        ^ ((const unsigned long *)arpinfo->iniface)[i])
                        & ((const unsigned long *)arpinfo->iniface_mask)[i];
        }

Alex Williamson suggested that I move 'u_int16_t invflags' up above
'char iniface[IFNAMSIZ]' in struct arpt_arp, since the u_int8_t is screwing up the
alignment.  Here's the patch I've been using to get around this on 2.4.24/25:

--- linux-2.4.24.aw/include/linux/netfilter_arp/arp_tables.h~   2003-08-25 05:44:44.000000000 -0600
+++ linux-2.4.24.aw/include/linux/netfilter_arp/arp_tables.h    2004-01-17 11:15:50.000000000 -0700
@@ -52,13 +52,14 @@
         * so there is no use in offering a way to do filtering on it.
         */
  
+       /* Inverse flags */
+       u_int16_t invflags;
+
        char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
        unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
  
        /* Flags word */
        u_int8_t flags;
-       /* Inverse flags */
-       u_int16_t invflags;
 };
  
 struct arpt_entry_target
