From: Joseph Murawski <dzoster@gmail.com>
Subject: Re: Sparc64 U60: no iptables
Date: Tue, 18 Oct 2005 22:13:15 -0400
Message-ID: <922692180510181913m3cce9b4bm8378552ec63cf08f@mail.gmail.com>
References: <4349614F.1010408@frankengul.org>
	 <20051009.202646.70198053.davem@davemloft.net>
	 <20051010082507.GA5157@frankengul.org>
	 <20051010.111611.106200571.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: debian-sparc@lists.debian.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932465AbVJSCNR@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20051010.111611.106200571.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello -

I would like to confirm this problem and reverting the patch provided
does fix the problem!

I have an ultra 60, dual processor.
gentoo linux   gentoo-sources 2.6.13-gentoo-r2

Whenever i would enable the iptables modules (ip_tables)
(ip_conntrack), execute the two commands iptables -X iptables -F and 
Ping any address ( including the loopback address)
i would get an oops.

I would just like to throw out my encounter with the problem and
confirm that the reversion of the below patch, fixes the problem and i
am able to use iptables with an smp kernel.

if i am commiting a mailing list no no by posting this please let me
know, but i thought it would be helpful to confirm this event.

Also is there a bugzilla type system for the linux kernel?

Thank you all for all your work!

any questions please let me know, i am also willing to report a bug
report if there is such a system in place.

--- a/net/ipv4/netfilter/ip_tables.c    2005-03-17 17:35:05 -08:00
+++ b/net/ipv4/netfilter/ip_tables.c    2005-03-17 17:35:05 -08:00
@@ -923,7 +923,7 @@
       }

       /* And one copy for every other CPU */
-       for (i = 1; i < NR_CPUS; i++) {
+       for (i = 1; i < num_possible_cpus(); i++) {
               memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
                      newinfo->entries,
                      SMP_ALIGN(newinfo->size));
@@ -945,7 +945,7 @@
               struct ipt_entry *table_base;
               unsigned int i;

-               for (i = 0; i < NR_CPUS; i++) {
+               for (i = 0; i < num_possible_cpus(); i++) {
                       table_base =
                               (void *)newinfo->entries
                               + TABLE_OFFSET(newinfo, i);
@@ -992,7 +992,7 @@
       unsigned int cpu;
       unsigned int i;

-       for (cpu = 0; cpu < NR_CPUS; cpu++) {
+       for (cpu = 0; cpu < num_possible_cpus(); cpu++) {
               i = 0;
               IPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
                                 t->size,
@@ -1130,7 +1130,7 @@
               return -ENOMEM;

       newinfo = vmalloc(sizeof(struct ipt_table_info)
-                         + SMP_ALIGN(tmp.size) * NR_CPUS);
+                         + SMP_ALIGN(tmp.size) * num_possible_cpus());
       if (!newinfo)
               return -ENOMEM;

@@ -1460,7 +1460,7 @@
               = { 0, 0, 0, { 0 }, { 0 }, { } };

       newinfo = vmalloc(sizeof(struct ipt_table_info)
-                         + SMP_ALIGN(repl->size) * NR_CPUS);
+                         + SMP_ALIGN(repl->size) * num_possible_cpus());
       if (!newinfo)
               return -ENOMEM;



On 10/10/05, David S. Miller <davem@davemloft.net> wrote:
> From: seb@frankengul.org
> Date: Mon, 10 Oct 2005 10:25:07 +0200
>
> > Indeed they are. Does the patch assume that cpus are numbered in a
> > row ?
>
> Yes, and that assumption is incorrect.
>
> > Now, I reverted the patch for ip_tables.c, ip6_tables.c and ebtables.c.
> > Everything is working ok (11h uptime).
>
> Right.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


--
Joseph Murawski
Hartford, CT
