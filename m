From: Pablo Neira <pablo@eurodev.net>
Subject: Re: sctp conntrack
Date: Mon, 02 Aug 2004 14:32:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <410E347A.6050307@eurodev.net>
References: <Pine.LNX.4.33.0408021352340.7180-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010500050200090305010700"
Cc: Harald Welte <laforge@netfilter.org>,
 Kiran Kumar <immidi_kiran@yahoo.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0408021352340.7180-100000@blackhole.kfki.hu>
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
--------------010500050200090305010700
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jozsef,

Jozsef Kadlecsik wrote:

>On Mon, 2 Aug 2004, Pablo Neira wrote:
>  
>
>>ip_conntrack_max is duplicated, is there any reason to do so? that's why
>>I remove that entry in the sysctl table.
>>    
>>
>
>Yes, that's intentional: we keep the backward compatible
>/proc/sys/net/ipv4/ip_conntrack_max besides the new
>/proc/sys/net/ipv4/netfilter/ip_conntrack_max
>  
>

ok, in that case, please take this patch instead.

regards,
Pablo

--------------010500050200090305010700
Content-Type: text/x-patch;
 name="sysctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysctl.patch"

diff -u -r1.1.1.1 sysctl.h
--- a/include/linux/sysctl.h	11 May 2004 13:35:37 -0000	1.1.1.1
+++ b/include/linux/sysctl.h	2 Aug 2004 11:47:49 -0000
@@ -776,6 +776,8 @@
 				  void __user *, size_t *);
 extern int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int,
 				      struct file *, void __user *, size_t *);
+extern int proc_doulongvec_jiffies_minmax(ctl_table *table, int,
+					  struct file *, void __user *, size_t *);
 
 extern int do_sysctl (int __user *name, int nlen,
 		      void __user *oldval, size_t __user *oldlenp,
diff -u -r1.1.1.1 sysctl.c
--- a/kernel/sysctl.c	11 May 2004 13:35:21 -0000	1.1.1.1
+++ b/kernel/sysctl.c	29 Jul 2004 13:21:22 -0000
@@ -1819,6 +1819,30 @@
 				     lenp, HZ, 1000l);
 }
 
+/**
+ * proc_doulongvec_jiffies_minmax - read a vector of second values with min/max values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned long) unsigned long
+ * values from/to the user buffer, treated as an ASCII string. The values
+ * are treated as milliseconds, and converted to jiffies when they are stored.
+ *
+ * This routine will ensure the values are within the range specified by
+ * table->extra1 (min) and table->extra2 (max).
+ *
+ * Returns 0 on success.
+ */
+int proc_doulongvec_jiffies_minmax(ctl_table *table, int write,
+				   struct file *filp,
+				   void __user *buffer, size_t *lenp)
+{
+    return do_proc_doulongvec_minmax(table, write, filp, buffer,
+		    		      lenp, HZ, 1l);
+}
 
 static int do_proc_dointvec_jiffies_conv(int *negp, unsigned long *lvalp,
 					 int *valp,
@@ -2157,6 +2181,13 @@
     return -ENOSYS;
 }
 
+int proc_doulongvec_jiffies_minmax(ctl_table *table, int write,
+				   struct file *filp,
+				   void __user *buffer, size_t *lenp)
+{
+    return -ENOSYS;
+}
+
 struct ctl_table_header * register_sysctl_table(ctl_table * table, 
 						int insert_at_head)
 {
@@ -2180,6 +2211,7 @@
 EXPORT_SYMBOL(proc_dostring);
 EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
+EXPORT_SYMBOL(proc_doulongvec_jiffies_minmax);
 EXPORT_SYMBOL(register_sysctl_table);
 EXPORT_SYMBOL(sysctl_intvec);
 EXPORT_SYMBOL(sysctl_jiffies);
diff -u -r1.4 ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	29 Jul 2004 13:23:24 -0000	1.4
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2 Aug 2004 11:59:40 -0000
@@ -356,97 +356,97 @@
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
 		.procname	= "ip_conntrack_tcp_timeout_syn_sent",
 		.data		= &ip_ct_tcp_timeout_syn_sent,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,
 		.procname	= "ip_conntrack_tcp_timeout_syn_recv",
 		.data		= &ip_ct_tcp_timeout_syn_recv,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED,
 		.procname	= "ip_conntrack_tcp_timeout_established",
 		.data		= &ip_ct_tcp_timeout_established,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT,
 		.procname	= "ip_conntrack_tcp_timeout_fin_wait",
 		.data		= &ip_ct_tcp_timeout_fin_wait,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT,
 		.procname	= "ip_conntrack_tcp_timeout_close_wait",
 		.data		= &ip_ct_tcp_timeout_close_wait,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK,
 		.procname	= "ip_conntrack_tcp_timeout_last_ack",
 		.data		= &ip_ct_tcp_timeout_last_ack,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT,
 		.procname	= "ip_conntrack_tcp_timeout_time_wait",
 		.data		= &ip_ct_tcp_timeout_time_wait,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE,
 		.procname	= "ip_conntrack_tcp_timeout_close",
 		.data		= &ip_ct_tcp_timeout_close,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT,
 		.procname	= "ip_conntrack_udp_timeout",
 		.data		= &ip_ct_udp_timeout,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM,
 		.procname	= "ip_conntrack_udp_timeout_stream",
 		.data		= &ip_ct_udp_timeout_stream,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT,
 		.procname	= "ip_conntrack_icmp_timeout",
 		.data		= &ip_ct_icmp_timeout,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT,
 		.procname	= "ip_conntrack_generic_timeout",
 		.data		= &ip_ct_generic_timeout,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_doulongvec_jiffies_minmax,
 	},
 	{ .ctl_name = 0 }
 };

--------------010500050200090305010700--
