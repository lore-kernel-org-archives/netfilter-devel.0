From: Philip Craig <philipc@snapgear.com>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Wed, 06 Jun 2007 15:49:28 +1000
Message-ID: <46664AE8.7020901@snapgear.com>
References: <465528CB.4020108@snapgear.com>	<200705250044.l4P0i3f8007580@toshiba.co.jp>	<4656342A.5040202@snapgear.com>	<4657FBD4.80506@trash.net>	<1180381991.6505.46.camel@henriknordstrom.net>	<465B72C0.5000907@snapgear.com>
	<1180488846.6505.310.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020306030609080003090509"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1180488846.6505.310.camel@henriknordstrom.net>
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
--------------020306030609080003090509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Henrik Nordstrom wrote:
> tis 2007-05-29 klockan 10:24 +1000 skrev Philip Craig:
>> I'll try that, but that will also prevent loop unrolling if you're
>> using -funroll-loops.  Not sure if any builds use this, but the
>> comment in the code implies some do.
> 
> My GCC unrolls that loop just fine...
> 
> x86_64 gcc (GCC) 4.1.1 20070105 (Red Hat 4.1.1-51)

You're right, I should check things before making statements.

> Here is a corrected version of the for loop:
> 
> for (i = 0, ret = 0;  i < IFNAMSIZ/sizeof(unsigned long) && ((const unsigned long *)ipinfo->outiface_mask)[i]; i++) {
> 
> 
> but for modern 64-bit CPUs I suspect the original is actually fastest as
> IFNAMSIZ is only 16 bytes and fits in two parallel 64-bit operations..

For my ARM platform, changing the for loop is a win for no interface
matches, or short interface names (I didn't test longer interface names).

But looking at the generated assembly for x86_64, this results in more
instructions and branches, and I can't see this being a win.  (I'm not
set up to profile this.) 

Also, the two optimisations are not mutually exclusive: one is to skip
the whole comparison completely (including inversion), and one is to
terminate the for loop early.  So we can use your loop termination
condition to skip the whole comparison too.

The attached patch is logically equivalent to my first (assuming a
contiguous and zero padded mask), but it avoids messing with flags.  In
practice, my profiling says it is slightly slower than the first patch
for 0 interface matches, but slightly faster for 1 or 2.

Note: this patch (and the original patch) change the behaviour when
inverting a zero length mask.  That is for either of:
	iptables -A INPUT ! -i +
	iptables -A INPUT ! -i ""
Not sure if this matters.

I also tried testing just the first byte, instead of a long, but that
was slower.

--------------020306030609080003090509
Content-Type: text/plain;
 name="iptables-iface-optim2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-iface-optim2.patch"

--- linux-2.6.x/net/ipv4/netfilter/ip_tables.c	26 Apr 2007 11:17:49 -0000	1.1.1.29
+++ linux-2.6.x/net/ipv4/netfilter/ip_tables.c	6 Jun 2007 05:45:16 -0000
@@ -112,30 +112,34 @@ ip_packet_match(const struct iphdr *ip,
 	}
 
 	/* Look for ifname matches; this should unroll nicely. */
-	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
-		ret |= (((const unsigned long *)indev)[i]
-			^ ((const unsigned long *)ipinfo->iniface)[i])
-			& ((const unsigned long *)ipinfo->iniface_mask)[i];
-	}
+	if (((const unsigned long *)ipinfo->iniface_mask)[0]) {
+		for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
+			ret |= (((const unsigned long *)indev)[i]
+				^ ((const unsigned long *)ipinfo->iniface)[i])
+				& ((const unsigned long *)ipinfo->iniface_mask)[i];
+		}
 
-	if (FWINV(ret != 0, IPT_INV_VIA_IN)) {
-		dprintf("VIA in mismatch (%s vs %s).%s\n",
-			indev, ipinfo->iniface,
-			ipinfo->invflags&IPT_INV_VIA_IN ?" (INV)":"");
-		return 0;
+		if (FWINV(ret != 0, IPT_INV_VIA_IN)) {
+			dprintf("VIA in mismatch (%s vs %s).%s\n",
+				indev, ipinfo->iniface,
+				ipinfo->invflags&IPT_INV_VIA_IN ?" (INV)":"");
+			return 0;
+		}
 	}
 
-	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
-		ret |= (((const unsigned long *)outdev)[i]
-			^ ((const unsigned long *)ipinfo->outiface)[i])
-			& ((const unsigned long *)ipinfo->outiface_mask)[i];
-	}
+	if (((const unsigned long *)ipinfo->outiface_mask)[0]) {
+		for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
+			ret |= (((const unsigned long *)outdev)[i]
+				^ ((const unsigned long *)ipinfo->outiface)[i])
+				& ((const unsigned long *)ipinfo->outiface_mask)[i];
+		}
 
-	if (FWINV(ret != 0, IPT_INV_VIA_OUT)) {
-		dprintf("VIA out mismatch (%s vs %s).%s\n",
-			outdev, ipinfo->outiface,
-			ipinfo->invflags&IPT_INV_VIA_OUT ?" (INV)":"");
-		return 0;
+		if (FWINV(ret != 0, IPT_INV_VIA_OUT)) {
+			dprintf("VIA out mismatch (%s vs %s).%s\n",
+				outdev, ipinfo->outiface,
+				ipinfo->invflags&IPT_INV_VIA_OUT ?" (INV)":"");
+			return 0;
+		}
 	}
 
 	/* Check specific protocol */

--------------020306030609080003090509--
