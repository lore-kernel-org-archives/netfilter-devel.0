From: Peter Riley <Peter.Riley@hotpop.com>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Fri, 31 Aug 2007 07:25:46 -0700
Message-ID: <46D824EA.1060406@hotpop.com>
References: <46D06522.2090509@hotpop.com>
	<46D06FF8.5090004@hotpop.com>	<46D5A5B9.2030107@trash.net>
	<46D6DEAF.9010009@hotpop.com>
	<Pine.LNX.4.64.0708302040350.24730@fbirervta.pbzchgretzou.qr>
Reply-To: Peter.Riley@hotpop.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090609040903020805070000"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708302040350.24730@fbirervta.pbzchgretzou.qr>
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
--------------090609040903020805070000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> On Aug 30 2007 08:13, Peter Riley wrote:
>> Patrick McHardy wrote:
>>>
>>> I count 132 occurences of nfcache (a few are in headers that must stay
>>> though). I'll happily apply a patch that kills them all.
>>>
>> Patrick, yes I get 134 occurrences on 132 lines in current svn.
>> The breakdown appears to me to be:
> [...]
> 
> Do we still need nfcache anyway?
> 

It seems to me there are three options....

Let's Make A Deal and say three "curtains":

Behind curtain #1 is... ** A Late-Summer Vacation Package in Las Vegas!! **

    You've worked hard enough, it's hot and dry out, so just do the minimum,
    kick back and relax...

    Leave the kernel headers alone, leave the iptables headers alone.
    Then

    struct xtables_match keeps    void (*init)(..., unsigned int *nfcache);
                                  int (*parse)(..., unsigned int *nfcache, ...);

    struct xtables_target keeps   void (*init)(..., unsigned int *nfcache);

    So the passing of *nfcache in the ->parse() and ->init() members of the
    extensions stays, plus the occurrences in the calls to them, and the
    debugging dump too.  But this is the bulk of the occurrences Patrick
    mentioned...  Only the small vestiges that actually do something are
    removed from is_same() and the two policy extensions.

    I hear the Vegas greens (shall I say browns?) ain't much good for golfing
    (nothing but sand traps in the desert), so the nfcache-golfing scores won't
    improve very much:  134 - 6 = 128.

    But the best part is: no one ever has to know! What happens in Vegas stays
    in Vegas.  No backwards compatibility breakage.

    It's a long patch-y road out to Las Vegas, but thankfully, with this option,
    Pablo already did most of the driving!

Behind curtain #2: ** Free enemas for you, and your friends! **

   Forget about ass-backwards compatibility and purge your cache! Alter the
   iptables extension API in xtables.h so the function prototypes for ->init()
   and ->parse() stop causing all the crap to be passed. But leave the really
   hard ob-struct-ion in your ipt_entry. It may be too painful to reach that
   deep down into the kernel to remove it.

   Then, you can flush out all of those toxins in the extensions and cleanse
   the calls to them in iptables.c.  Those nasty blockages that iptables can't
   purge because of the (a->nfcache != b->nfcache) comparison can be rooted out
   too (as in #1).

   But let's be realistic, the fresh healthy feeling won't last forever.
   The next time you come down with a bug and really need to make a dump,
   dump_entry() should still be able to pass the bits of cache out of your
   ipt_entry.  At least keep this bit:  printf("Cache: %08X ", e->nfcache);

   Now, every john out there with cache stuck in his libipt_POOBAR.c extension
   is going to have to join in.  So the downside is, while this option might be
   cathartic for you, some of your friends may end up feeling a little ... violated.
   And to be pointed and blunt (ouch), a lot of old code will go into the toilet,
   down the drain.

   With that newfound looseness in the hips, though, your handicap can greatly
   improve:  nfcache-golf score = 134 - 128 = 6.


Behind curtain #3: Is that a goat? a gnu?  No, a penguin!!
         (Plus we'll let your friends can keep their enemas.  Penguin gets one too!)

   Go deeper, purge every last one of the 134 stinky bits of nfcache! The iptables
   headers change as before, and now kernel headers ip_tables.h and ip6_tables.h
   can drop nfcache in struct ipt_entry/compat_ipt_entry/ip6t_entry.  Even get rid
   of the #define NFC_* in ./include/linux/netfilter*.h.  Hold nothing back...

   Those with kernel patches or userspace tools will all just have to suck it up
   like the extensions people had to in #2.  But when you're asked what you did
   last summer, you'll have a big change to tell them about!  :-)


Time to choose!

(Apologies to Monty Hall, The City of Las Vegas, and all who thought that was lame...)

Best Regards,
Peter

PS- My vote, if indeed I have one, is for #1 with no breakage of backwards
compatibility. See the fixed up patch attached. Is it worthwhile to go further?




--------------090609040903020805070000
Content-Type: text/plain;
 name="iptables-summer-in-vegas.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-summer-in-vegas.patch"

diff -Naur iptables.orig/extensions/libip6t_policy.c iptables/extensions/libip6t_policy.c
--- iptables.orig/extensions/libip6t_policy.c	2007-08-31 06:20:54.000000000 -0700
+++ iptables/extensions/libip6t_policy.c	2007-08-31 06:22:58.000000000 -0700
@@ -135,7 +135,6 @@
 
 static void init(struct xt_entry_match *m, unsigned int *nfcache)
 {
-	*nfcache |= NFC_UNKNOWN;
 }
 
 static int parse_direction(char *s)
diff -Naur iptables.orig/extensions/libipt_policy.c iptables/extensions/libipt_policy.c
--- iptables.orig/extensions/libipt_policy.c	2007-08-31 06:20:55.000000000 -0700
+++ iptables/extensions/libipt_policy.c	2007-08-31 06:23:11.000000000 -0700
@@ -95,7 +95,6 @@
 
 static void init(struct xt_entry_match *m, unsigned int *nfcache)
 {
-	*nfcache |= NFC_UNKNOWN;
 }
 
 static int parse_direction(char *s)
diff -Naur iptables.orig/libiptc/libip4tc.c iptables/libiptc/libip4tc.c
--- iptables.orig/libiptc/libip4tc.c	2007-08-31 06:20:51.000000000 -0700
+++ iptables/libiptc/libip4tc.c	2007-08-31 06:23:53.000000000 -0700
@@ -204,8 +204,7 @@
 			return NULL;
 	}
 
-	if (a->nfcache != b->nfcache
-	    || a->target_offset != b->target_offset
+	if (a->target_offset != b->target_offset
 	    || a->next_offset != b->next_offset)
 		return NULL;
 
diff -Naur iptables.orig/libiptc/libip6tc.c iptables/libiptc/libip6tc.c
--- iptables.orig/libiptc/libip6tc.c	2007-08-31 06:20:51.000000000 -0700
+++ iptables/libiptc/libip6tc.c	2007-08-31 06:24:12.000000000 -0700
@@ -236,8 +236,7 @@
 			return NULL;
 	}
 
-	if (a->nfcache != b->nfcache
-	    || a->target_offset != b->target_offset
+	if (a->target_offset != b->target_offset
 	    || a->next_offset != b->next_offset)
 		return NULL;
 








--------------090609040903020805070000--
