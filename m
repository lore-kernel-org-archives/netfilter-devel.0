From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: [PATCH] IPv6 SMP fix
Date: Thu, 03 Oct 2002 19:03:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1033664602.1062.4.camel@arwen>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_sukEvtkHkvZ+Fkxy9tXHKA)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary_(ID_sukEvtkHkvZ+Fkxy9tXHKA)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Hi,

- fixed TABLE_OFFSET macro
- set the owner of the proc entry

The original problem (bad counter values at Sparc64) remained: this
problem exists in IPv4, too!

kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /------------------------------------------->

--Boundary_(ID_sukEvtkHkvZ+Fkxy9tXHKA)
Content-type: text/plain; name=counter.20021003; charset=ISO-8859-2
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=counter.20021003

--- linux/net/ipv6/netfilter/ip6_tables.c.old	Thu Oct  3 18:35:19 2002
+++ linux/net/ipv6/netfilter/ip6_tables.c	Thu Oct  3 18:50:46 2002
@@ -111,7 +111,7 @@
 #define ADD_COUNTER(c,b,p) do { (c).bcnt += (b); (c).pcnt += (p); } while(0)
 
 #ifdef CONFIG_SMP
-#define TABLE_OFFSET(t,p) (SMP_ALIGN((t)->size)*cpu_number_map(p))
+#define TABLE_OFFSET(t,p) (SMP_ALIGN((t)->size)*(p))
 #else
 #define TABLE_OFFSET(t,p) 0
 #endif
@@ -358,7 +358,8 @@
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 	table_base = (void *)table->private->entries
-		+ TABLE_OFFSET(table->private, smp_processor_id());
+		+ TABLE_OFFSET(table->private, 
+				cpu_number_map(smp_processor_id()));
 	e = get_entry(table_base, table->private->hook_entry[hook]);
 
 #ifdef CONFIG_NETFILTER_DEBUG
@@ -589,7 +590,7 @@
 				= (void *)ip6t_get_target(e);
 
 			if (e->comefrom & (1 << NF_IP6_NUMHOOKS)) {
-				printk("iptables: loop hook %u pos %u %08X.\n",
+				printk("ip6tables: loop hook %u pos %u %08X.\n",
 				       hook, pos, e->comefrom);
 				return 0;
 			}
@@ -936,7 +937,7 @@
 
 	/* And one copy for every other CPU */
 	for (i = 1; i < smp_num_cpus; i++) {
-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size*i),
+		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
 		       newinfo->entries,
 		       SMP_ALIGN(newinfo->size));
 	}
@@ -1491,6 +1492,9 @@
 	duprintf("table->private->number = %u\n",
 		 table->private->number);
 
+	/* save number of initial entries */
+	table->private->initial_entries = table->private->number;
+
 	table->lock = RW_LOCK_UNLOCKED;
 	list_prepend(&ip6t_tables, table);
 
@@ -1818,9 +1822,15 @@
 	}
 
 #ifdef CONFIG_PROC_FS
-	if (!proc_net_create("ip6_tables_names", 0, ip6t_get_tables)) {
+	{
+	struct proc_dir_entry *proc;
+
+	proc = proc_net_create("ip6_tables_names", 0, ip6t_get_tables);
+	if (!proc) {
 		nf_unregister_sockopt(&ip6t_sockopts);
 		return -ENOMEM;
+	}
+	proc->owner = THIS_MODULE;
 	}
 #endif
 

--Boundary_(ID_sukEvtkHkvZ+Fkxy9tXHKA)--
