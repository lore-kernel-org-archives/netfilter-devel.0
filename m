From: Brad Fisher <brad@info-link.net>
Subject: [PATCH] Re: Time match in mangle/POSTROUTING?
Date: Wed, 03 Dec 2003 14:10:08 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCE4320.6727F0A7@info-link.net>
References: <3FCD2AA1.6F5E0225@info-link.net> <3FCD305F.4040406@trash.net> <3FCD3306.50603@trash.net> <3FCD3475.D4D0A063@info-link.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------4F70CDD0AB066A9A1B572B40"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
        Netfilter Development Mailinglist
 <netfilter-devel@lists.netfilter.org>,
        fabrice@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------4F70CDD0AB066A9A1B572B40
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

> > Patrick McHardy wrote:
> >
> > Even better, in POSTROUTING only use the kerneltime when the skb stamp
> > is unset, that way you save expensive gettimeofday calls for forwarded
> > packets.
> > To make it clean, just remove the kerneltime option completely and only
> > look if the stamp is set or unset.

That seems to work well.  I made the following changes:

* If skb->stamp.tv_sec is 0, the timestamp is grabbed via gettimeofday, otherwise
the skb stamp is used.

* I don't see any reason why the above approach wouldn't work in any chain, so I
removed the check from checkentry.

* Since the kerneltime flag was no longer needed, it was removed from the
ipt_time_info struct.  This will probably cause a binary incompatibility.

* I streamlined the localtime function to not calculate the year, dom, or month
since these values are never used.  If the time match is modified in the future to
match on any of these values, they will need to be re-enabled (I just #if 0'd the
appropriate lines).

* The time comparison was modified to allow the start time to fall after the end
time (for example, start 23:00 end 02:00 will match between 11pm and 2am, instead
of the old behavior which would match the two ranges 00:00-23:00 and 02:00-23:59
(or basically any time).

Patch for patch-o-matic-20030912 is attached.  Should be able to apply with "patch
-p1".

-Brad

--------------4F70CDD0AB066A9A1B572B40
Content-Type: text/plain; charset=us-ascii;
 name="patch-o-matic-20030912.time.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-o-matic-20030912.time.diff"

diff -urN patch-o-matic-20030912.orig/base/time.patch patch-o-matic-20030912.new/base/time.patch
--- patch-o-matic-20030912.orig/base/time.patch	Tue Oct 22 05:15:20 2002
+++ patch-o-matic-20030912.new/base/time.patch	Wed Dec  3 13:48:49 2003
@@ -1,7 +1,7 @@
-diff -uNr original/linux/include/linux/netfilter_ipv4/ipt_time.h linux/include/linux/netfilter_ipv4/ipt_time.h
---- original/linux/include/linux/netfilter_ipv4/ipt_time.h	Thu Jan  1 07:30:00 1970
-+++ linux/include/linux/netfilter_ipv4/ipt_time.h	Thu Dec  6 12:27:04 2001
-@@ -0,0 +1,13 @@
+diff -urN linux-2.4.23.orig/include/linux/netfilter_ipv4/ipt_time.h linux-2.4.23.time/include/linux/netfilter_ipv4/ipt_time.h
+--- linux-2.4.23.orig/include/linux/netfilter_ipv4/ipt_time.h	Wed Dec 31 18:00:00 1969
++++ linux-2.4.23.time/include/linux/netfilter_ipv4/ipt_time.h	Wed Dec  3 13:46:30 2003
+@@ -0,0 +1,12 @@
 +#ifndef __ipt_time_h_included__
 +#define __ipt_time_h_included__
 +
@@ -10,15 +10,14 @@
 +	u_int8_t  days_match;   /* 1 bit per day. -SMTWTFS                      */
 +	u_int16_t time_start;   /* 0 < time_start < 23*60+59 = 1439             */
 +	u_int16_t time_stop;    /* 0:0 < time_stat < 23:59                      */
-+	u_int8_t  kerneltime;   /* ignore skb time (and use kerneltime) or not. */
 +};
 +
 +
 +#endif /* __ipt_time_h_included__ */
-diff -uNr original/linux/net/ipv4/netfilter/ipt_time.c linux/net/ipv4/netfilter/ipt_time.c
---- original/linux/net/ipv4/netfilter/ipt_time.c	Thu Jan  1 07:30:00 1970
-+++ linux/net/ipv4/netfilter/ipt_time.c	Thu Dec  6 13:02:14 2001
-@@ -0,0 +1,185 @@
+diff -urN linux-2.4.23.orig/net/ipv4/netfilter/ipt_time.c linux-2.4.23.time/net/ipv4/netfilter/ipt_time.c
+--- linux-2.4.23.orig/net/ipv4/netfilter/ipt_time.c	Wed Dec 31 18:00:00 1969
++++ linux-2.4.23.time/net/ipv4/netfilter/ipt_time.c	Wed Dec  3 13:45:44 2003
+@@ -0,0 +1,189 @@
 +/*
 +  This is a module which is used for time matching
 +  It is using some modified code from dietlibc (localtime() function)
@@ -43,6 +42,12 @@
 +MODULE_DESCRIPTION("Match arrival timestamp");
 +MODULE_LICENSE("GPL");
 +
++
++/*
++  Not all fields in the struct tm are initialized by the localtime function below.
++  Currently, only tm_sec, tm_min, tm_hour, and tm_wday are initialized.
++*/
++
 +struct tm
 +{
 +	int tm_sec;                   /* Seconds.     [0-60] (1 leap second) */
@@ -80,7 +85,7 @@
 +	time_t packet_local_time;
 +
 +	/* if kerneltime=1, we don't read the skb->timestamp but kernel time instead */
-+	if (info->kerneltime)
++	if (skb->stamp.tv_sec == 0)
 +	{
 +		do_gettimeofday(&kerneltimeval);
 +		packet_local_time = kerneltimeval.tv_sec;
@@ -97,8 +102,15 @@
 +
 +	/* ... check the time now */
 +	packet_time = (currenttime.tm_hour * 60) + currenttime.tm_min;
-+	if ((packet_time < info->time_start) || (packet_time > info->time_stop))
-+		return 0;
++	if (info->time_start <= info->time_stop) {
++		/* normal order: start <= stop */
++		if ((packet_time < info->time_start) || (packet_time > info->time_stop))
++                        return 0;
++        } else {
++		/* reversed order: stop < start */
++                if ((packet_time < info->time_start) && (packet_time > info->time_stop))
++                        return 0;
++        }
 +
 +	/* here we match ! */
 +	return 1;
@@ -113,20 +125,6 @@
 +{
 +	struct ipt_time_info *info = matchinfo;   /* match info for rule */
 +
-+	/* First, check that we are in the correct hook */
-+	/* PRE_ROUTING, LOCAL_IN or FROWARD */
-+	if (hook_mask
-+            & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT)))
-+	{
-+		printk("ipt_time: error, only valid for PRE_ROUTING, LOCAL_IN, FORWARD and OUTPUT)\n");
-+		return 0;
-+	}
-+	/* we use the kerneltime if we are in forward or output */
-+	info->kerneltime = 1;
-+	if (hook_mask & ~((1 << NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT))) 
-+		/* if not, we use the skb time */
-+		info->kerneltime = 0;
-+
 +	/* Check the size */
 +	if (matchsize != IPT_ALIGN(sizeof(struct ipt_time_info)))
 +		return 0;
@@ -167,9 +165,10 @@
 +
 +void
 +localtime(const time_t *timepr, struct tm *r) {
-+	time_t i;
 +	time_t timep;
 +	extern struct timezone sys_tz;
++#if 0
++	time_t i;
 +	const unsigned int __spm[12] =
 +		{ 0,
 +		  (31),
@@ -184,6 +183,7 @@
 +		  (31+28+31+30+31+30+31+31+30+31),
 +		  (31+28+31+30+31+30+31+31+30+31+30),
 +		};
++#endif
 +	register time_t work;
 +
 +	timep = (*timepr) - (sys_tz.tz_minuteswest * 60);
@@ -192,6 +192,8 @@
 +	r->tm_min=work%60; r->tm_hour=work/60;
 +	work=timep/(SPD);
 +	r->tm_wday=(4+work)%7;
++#if 0
++	/* The following will only be needed if the time match is extended to allow matching my month/year/dom/doy */
 +	for (i=1970; ; ++i) {
 +		register time_t k= (!(i%4) && ((i%100) || !(i%400)))?366:365;
 +		if (work>k)
@@ -203,4 +205,5 @@
 +	for (i=11; i && __spm[i]>work; --i) ;
 +	r->tm_mon=i;
 +	r->tm_mday=work-__spm[i]+1;
++#endif
 +}

--------------4F70CDD0AB066A9A1B572B40--
