From: Pablo Neira <pablo@eurodev.net>
Subject: Re: sctp conntrack
Date: Mon, 02 Aug 2004 13:34:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <410E26DB.2070307@eurodev.net>
References: <20040722191649.GJ14946@obroa-skai.de.gnumonks.org> <200407271348.34615.immidi@spymac.com> <20040801165005.GA14539@sunbeam2> <200408021555.38315.immidi@spymac.com> <20040802110522.GN18758@sunbeam2>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050603060006050503060104"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
 Kiran Kumar <immidi_kiran@yahoo.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040802110522.GN18758@sunbeam2>
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
--------------050603060006050503060104
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

Harald Welte wrote:

>On Mon, Aug 02, 2004 at 03:55:38PM +0530, Kiran Kumar Immidi wrote:
>  
>
>>On Sunday 01 August 2004 10:20 pm, Harald Welte wrote:
>>
>>    
>>
>>>>- The type of these timeouts in case of TCP is unsigned long, though the
>>>>code in ip_conntrack_standalone.c treats them as unsigned int. I am not
>>>>sure of the working, but I suspect something wrong here. I have followed
>>>>the same pattern however.
>>>>        
>>>>
>>>yes, indeed. on 64bit archs this is going to cause trouble :(
>>>      
>>>

I've observed this problem two weeks ago, actually I prepared a patch 
but I was a bit busy to post it to the mailling list. I just tried it 
with my current kernel and works for me. If missing anything, please let 
me know.

regards,
Pablo

--------------050603060006050503060104
Content-Type: text/x-patch;
 name="sysctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysctl.patch"

diff -u -r1.1.1.1 sysctl.c
--- a/kernel/sysctl.c	29 Jul 2004 13:06:24 -0000	1.1.1.1
+++ b/kernel/sysctl.c	29 Jul 2004 13:15:31 -0000
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
diff -u -r1.1.1.1 ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	29 Jun 2004 14:04:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	29 Jul 2004 13:13:12 -0000
@@ -356,103 +356,101 @@
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
 
-#define NET_IP_CONNTRACK_MAX 2089
-
 static ctl_table ip_ct_netfilter_table[] = {
 	{
 		.ctl_name	= NET_IPV4_NETFILTER,
@@ -460,14 +458,6 @@
 		.mode		= 0555,
 		.child		= ip_ct_sysctl_table,
 	},
-	{
-		.ctl_name	= NET_IP_CONNTRACK_MAX,
-		.procname	= "ip_conntrack_max",
-		.data		= &ip_conntrack_max,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
-	},
 	{ .ctl_name = 0 }
 };
 

--------------050603060006050503060104--
