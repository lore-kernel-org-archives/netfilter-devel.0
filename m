From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] clean up for conntrack stats
Date: Thu, 07 Oct 2004 00:41:13 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41647489.2090402@eurodev.net>
References: <4162B517.8030200@eurodev.net> <41642FAC.6050406@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000604080904080707060905"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41642FAC.6050406@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000604080904080707060905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Patrick McHardy wrote:

>> a) I combined ifdef's checkings + macro, so if conntrack stats are 
>> compiled in the kernel we increase the counters.
>>
>> #define CONNTRACK_STAT_INC(count) 
>> (__get_cpu_var(ip_conntrack_stat).count++)
>> +#else /* !CONNTRACK STATS */
>> +#define CONNTRACK_STAT_INC(count)
>> +#endif
>
>
> I don't think we should make these configurable, they don't
> cost much.


I talk about this below

>> b) Martin, I've killed this to make them use the macro, are you ok 
>> with this? I know that we call twice smp_proccesor_id now, but it's 
>> clean I think.
>>
>> -       /* use per_cpu() to avoid multiple calls to 
>> smp_processor_id() */
>> -       unsigned int cpu = smp_processor_id();
>>
>>        MUST_BE_READ_LOCKED(&ip_conntrack_lock);
>>        list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
>>                if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
>> -                       per_cpu(ip_conntrack_stat, cpu).found++;
>> +                       CONNTRACK_STAT_INC(found);
>>                        return h;
>>
>
> Please send this part as a seperate patch.


attached to this email, conntrack_find-stats-cleanup.patch file.

>> c) This is similar to a)
>>
>> +#define CT_ADD_COUNTERS(ct, ctinfo, skb) ct_add_counters(ct, ctinfo, 
>> skb)
>> +#else
>> +#define CT_ADD_COUNTERS(ct, ctinfo, skb)
>> +#endif
>
>
>
> Why this change ? ct_add_counters is an inline function with an
> empty body when CONFIG_IP_NF_CT_ACCT is undefined.


True, it changes nothing. Packet counting vanishes if 
CONFIG_IP_NF_CT_ACCT is unset, to make the system consistent maybe we 
should make vanish normal stats counting as well. See 
ct-stat-macro-vanishes.patch file. If you don't like it anyway, drop it :-).

>> d) You can see that I've play around with ip_conntrack_standalone 
>> reordering the creation of /proc entries. I did it just to remove 
>> warnings about unused labels when unsetting conntrack stats.
>>
>> To conclude, this patch adds up to 8 ifdef's CONFIG_IP_NF_CT_ACCT 
>> checkings, I must confess that I don't love them, I'll think if 
>> there's a way to do cleaner.
>
>
>
> I thought this was a cleanup-patch. Adding ifdefs is
> usually not considered cleanup :) It costs alot more time
> to review patches with multiple (mostly) unrelated changes,
> please send stuff like this as multiple small patches in
> the future.


Thanks for the tip :-).

I've attached another patch, see fix-remove-ip_conntrack_expect.patch 
file, if conntrack stats are set, ip_conntrack is compiled as module and 
you unload it, ip_conntrack_expect entry in /proc stays there forever.

regards,
Pablo

--------------000604080904080707060905
Content-Type: text/x-patch;
 name="conntrack_find-stats-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack_find-stats-cleanup.patch"

===== net/ipv4/netfilter/ip_conntrack_core.c 1.68 vs edited =====
--- 1.68/net/ipv4/netfilter/ip_conntrack_core.c	Wed Sep 29 05:34:27 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	Wed Oct  6 23:53:17 2004
@@ -352,16 +352,14 @@
 {
 	struct ip_conntrack_tuple_hash *h;
 	unsigned int hash = hash_conntrack(tuple);
-	/* use per_cpu() to avoid multiple calls to smp_processor_id() */
-	unsigned int cpu = smp_processor_id();
 
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
 	list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
 		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
-			per_cpu(ip_conntrack_stat, cpu).found++;
+			CONNTRACK_STAT_INC(found);
 			return h;
 		}
-		per_cpu(ip_conntrack_stat, cpu).searched++;
+		CONNTRACK_STAT_INC(searched);
 	}
 
 	return NULL;

--------------000604080904080707060905
Content-Type: text/x-patch;
 name="ct-stat-macro-vanishes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ct-stat-macro-vanishes.patch"

===== include/linux/netfilter_ipv4/ip_conntrack.h 1.23 vs edited =====
--- 1.23/include/linux/netfilter_ipv4/ip_conntrack.h	Thu Sep 23 23:45:10 2004
+++ edited/include/linux/netfilter_ipv4/ip_conntrack.h	Wed Oct  6 23:57:04 2004
@@ -311,7 +311,11 @@
 	unsigned int expect_delete;
 };
 
+#ifdef CONFIG_IP_NF_CT_ACCT
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
+#else /* !CONNTRACK STATS */
+#define CONNTRACK_STAT_INC(count)
+#endif 
 
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \

--------------000604080904080707060905
Content-Type: text/x-patch;
 name="fix-remove-ip_conntrack_expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-remove-ip_conntrack_expect.patch"

===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.50 vs edited =====
--- 1.50/net/ipv4/netfilter/ip_conntrack_standalone.c	Tue Sep 28 23:22:13 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	Wed Oct  6 23:46:59 2004
@@ -815,8 +815,8 @@
  cleanup_proc_stat:
 #ifdef CONFIG_PROC_FS
 	proc_net_remove("ip_conntrack_stat");
-cleanup_proc_exp:
-	proc_net_remove("ip_conntrack_exp");
+ cleanup_proc_exp:
+	proc_net_remove("ip_conntrack_expect");
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:

--------------000604080904080707060905--
