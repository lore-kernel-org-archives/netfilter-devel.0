From: Amin Azez <azez@ufomechanic.net>
Subject: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 12:52:55 +0000
Message-ID: <45F7F027.9050300@ufomechanic.net>
References: <et6fp4$l04$1@sea.gmane.org>	
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>	
	<45F6CD7C.40708@ufomechanic.net>	
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>	
	<1173868532.26913.39.camel@henriknordstrom.net>	
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050208020900010208000809"
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1173876211.26913.73.camel@henriknordstrom.net>
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
--------------050208020900010208000809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

* Henrik Nordstrom wrote, On 14/03/07 12:43:
> ons 2007-03-14 klockan 12:02 +0100 skrev Patrick McHardy:
>
>   
>> Thats true, routing by nfmark in the OUTPUT chain needs the rerouting
>> done by the mangle table, but nowadays there are other uses for nfmark,
>> so if someone feels motivated to send a patch to get rid of this pretty
>> arbitary restriction I think I would take it.
>>     
>
> If you do, please remove the same restriction from CONNMARK restore
>   
Let it at least be said that some of my patches are used :-)

(Henrick, are you interested in my per-flow patch for connmark, so that
each side of the flow can have a seperate mark? Also dumped thus out of
/proc/net/ip-conntrack and libnfnetlink)

Signed-off-by: Sam Liddicott <azez@ufomechanic.net>

Sam



--------------050208020900010208000809
Content-Type: text/x-patch;
 name="mark-mangle.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mark-mangle.patch"

Index: linux-2.6.17.1/net/netfilter/xt_CONNMARK.c
===================================================================
--- linux-2.6.17.1.orig/net/netfilter/xt_CONNMARK.c
+++ linux-2.6.17.1/net/netfilter/xt_CONNMARK.c
@@ -133,13 +133,6 @@ checkentry(const char *tablename,
 {
        struct xt_connmark_target_info *matchinfo = targinfo;
 
-       if (matchinfo->mode == XT_CONNMARK_RESTORE) {
-           if (strcmp(tablename, "mangle") != 0) {
-                   printk(KERN_WARNING "CONNMARK: restore can only be called from \"mangle\" table, not \"%s\"\n", tablename);
-                   return 0;
-           }
-       }
-
        if (matchinfo->mark > 0xffffffff || matchinfo->mask > 0xffffffff) {
                printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
                return 0;
Index: linux-2.6.17.1/net/netfilter/xt_MARK.c
===================================================================
--- linux-2.6.17.1.orig/net/netfilter/xt_MARK.c
+++ linux-2.6.17.1/net/netfilter/xt_MARK.c
@@ -116,7 +116,6 @@ static struct xt_target ipt_mark_reg_v0 
        .name           = "MARK",
        .target         = target_v0,
        .targetsize     = sizeof(struct xt_mark_target_info),
-       .table          = "mangle",
        .checkentry     = checkentry_v0,
        .me             = THIS_MODULE,
        .family         = AF_INET,
@@ -127,7 +126,6 @@ static struct xt_target ipt_mark_reg_v1 
        .name           = "MARK",
        .target         = target_v1,
        .targetsize     = sizeof(struct xt_mark_target_info_v1),
-       .table          = "mangle",
        .checkentry     = checkentry_v1,
        .me             = THIS_MODULE,
        .family         = AF_INET,
@@ -138,7 +136,6 @@ static struct xt_target ip6t_mark_reg_v0
        .name           = "MARK",
        .target         = target_v0,
        .targetsize     = sizeof(struct xt_mark_target_info),
-       .table          = "mangle",
        .checkentry     = checkentry_v0,
        .me             = THIS_MODULE,
        .family         = AF_INET6,

--------------050208020900010208000809--
