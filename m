From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Tue, 05 Jun 2007 15:32:38 +0200
Message-ID: <466565F6.7070902@trash.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>	<200706031047.44848.dim@openvz.org> <4662F2E9.1090903@trash.net>	<200706041154.11187.dim@openvz.org> <4665542F.9020607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070602000608030908010609"
Cc: sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dmitry Mishin <dim@openvz.org>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <4665542F.9020607@trash.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070602000608030908010609
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Dmitry Mishin wrote:
> 
>>It's better, but I see the issue with iterate with compat_check_entry() calls.
>>If it fails, some of target/matches' check_* functions are called, some not.
>>Please, review my version of this patch.
> 
> 
> 
> You're right again, thanks. Patch applied.
> 

With one minor change:


--------------070602000608030908010609
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 9c294a5..e992cd6 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -265,14 +265,17 @@ ipt_get_target(struct ipt_entry *e)
 })
 
 /* fn returns 0 to continue iteration */
-#define IPT_ENTRY_ITERATE_CONTINUE(entries, size, i, fn, args...) \
+#define IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
 ({								\
-	unsigned int __i;					\
+	unsigned int __i, __n;					\
 	int __ret = 0;						\
 	struct ipt_entry *__entry;				\
 								\
-	for (__i = i; __i < (size); __i += __entry->next_offset) { \
+	for (__i = 0, __n = 0; __i < (size);			\
+	     __i += __entry->next_offset, __n++) { 		\
 		__entry = (void *)(entries) + __i;		\
+		if (__n < n)					\
+			continue;				\
 								\
 		__ret = fn(__entry , ## args);			\
 		if (__ret != 0)					\

--------------070602000608030908010609--
