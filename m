From: Sven Anders <anders@anduras.de>
Subject: Re: limit and negation
Date: Tue, 09 Nov 2004 15:55:00 +0100
Message-ID: <4190DA44.10207@anduras.de>
References: <1099995187.4318.15.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040509090409040401080404"
Cc: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1099995187.4318.15.camel@porky>
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

This is a multi-part message in MIME format.
--------------040509090409040401080404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Eric Leblond wrote:
> Hi,
> 
> On a discussion yesterday on #netfilter, someone point out that the
> limit seems to have problem with negation.
> Man page announce it is supported, but when doing this test :
> iptables rules set :
> iptables -A OUTPUT -m limit --limit 1/s -j LOG --log-prefix "under"
> iptables -A OUTPUT -m limit ! --limit 1/s -j LOG --log-prefix "over"
> 
> It seems that the rules match the same packets (same ID on tcp flows).
> 
> I never had to use limit with a negation, but there's at least a problem
> in the man page.

Yes, the manual page is wrong. It's not implemented.
I'm wondering, that you did not get an error-message...

I attached a patch for it (but it breaks compatibilty, so I think nobody
will correct it...)

Regards
  Sven

-- 
  Sven Anders <anders@anduras.de>

  ANDURAS service solutions AG
  Innstraße 71 - 94036 Passau - Germany
  Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Karlheinz Antesberger

--------------040509090409040401080404
Content-Type: text/plain;
 name="ipt_limit-inverse.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_limit-inverse.patch"


# Limit rule can now be inversed.
# So it's possible to match, if the limit is exceeded and drop the packet.
#
# Sven Anders <anders@anduras.de>

--- linux-2.4.22/include/linux/netfilter_ipv4/ipt_limit.h.orig	Wed Sep  8 16:22:59 2004
+++ linux-2.4.22/include/linux/netfilter_ipv4/ipt_limit.h	Wed Sep  8 16:46:15 2004
@@ -4,9 +4,14 @@
 /* timings are in milliseconds. */
 #define IPT_LIMIT_SCALE 10000
 
+/* invert match? */
+#define IPT_LIMIT_MATCH_BELOW  0x00
+#define IPT_LIMIT_MATCH_ABOVE  0x01
+
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 struct ipt_rateinfo {
+        u_int8_t flags;   /* Match if, below or above limit? */
 	u_int32_t avg;    /* Average secs between packets * scale */
 	u_int32_t burst;  /* Period multiplier for upper limit. */
 
--- linux-2.4.22/net/ipv4/netfilter/ipt_limit.c.orig	Wed Sep  8 16:31:22 2004
+++ linux-2.4.22/net/ipv4/netfilter/ipt_limit.c	Wed Sep  8 16:47:09 2004
@@ -6,7 +6,9 @@
  * 2 September 1999: Changed from the target RATE to the match
  *                   `limit', removed logging.  Did I mention that
  *                   Alexey is a fucking genius?
- *                   Rusty Russell (rusty@rustcorp.com.au).  */
+ *                   Rusty Russell (rusty@rustcorp.com.au). 
+ * 8 September 2004: Added inversion, Sven Anders <anders@anduras.de>
+ */
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
@@ -52,6 +54,7 @@
 		int *hotdrop)
 {
 	struct ipt_rateinfo *r = ((struct ipt_rateinfo *)matchinfo)->master;
+	struct ipt_rateinfo *info = (struct ipt_rateinfo *)matchinfo;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
@@ -63,11 +66,11 @@
 		/* We're not limited. */
 		r->credit -= r->cost;
 		spin_unlock_bh(&limit_lock);
-		return 1;
+		return !(info->flags & IPT_LIMIT_MATCH_ABOVE);
 	}
 
        	spin_unlock_bh(&limit_lock);
-	return 0;
+	return (info->flags & IPT_LIMIT_MATCH_ABOVE);
 }
 
 /* Precision saver. */

--------------040509090409040401080404--
