From: Herve Eychenne <rv@wallfire.org>
Subject: [PATCH] Re: hashsize available through /proc was RAM and conntrack performance: first draft of the document is online
Date: Thu, 27 Nov 2003 05:14:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127041452.GD1084@eychenne.org>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org> <20031125153543.GD1082@eychenne.org> <20031125205723.GE2971@obroa-skai.de.gnumonks.org> <20031126034231.GA1044@eychenne.org> <20031126113645.GF3121@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031126113645.GF3121@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 26, 2003 at 12:36:45PM +0100, Harald Welte wrote:

> On Wed, Nov 26, 2003 at 04:42:32AM +0100, Herve Eychenne wrote:

> > > > So, it cannot be read at runtime, I suppose... It would be really nice,
> > > > though... would /proc be ok?
> > 
> > > yes. It is printed at startup via syslog, however.
> > 
> > Syslog can be enough for humans, but not for scripts...
> > I think you can add "make hashsize value available through /proc" to
> > the TODO list (whose size is unfortunately ever growing ;-)).

> i'd rather write a patch than add it to the todo list.  adding and
> removing that item from the list would be about the same amount of work,
> i guess.

I had a quick look at the existing code in ip_conntrack_core.c.

First I would have been happy to write a small patch, but I'm not really a
kernel guy and register_sysctl_table API seems _completely crappy_ to
me.

So I took the risk to ridiculize myself in public and wrote something, though,
but I'm unsure about my patch. Especially unsure about the Binary ID of
the ctl_table... I took NET_IP_CONNTRACK_MAX + 1 = 2090 because I could find
no occurence of 2090 user for sysctl in the whole kernel tree... but it
seems crappy and hazardous. Who the hell is in charge of ensuring the
unicity of each sysctl binary entry? Where's the list?

So I didn't even took time to compile the attached patch, but with the help of
gods if will hopefully work.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ip_conntrack_core.c.patch"

--- ip_conntrack_core.c.old	2003-11-27 04:59:57.000000000 +0100
+++ ip_conntrack_core.c.new	2003-11-27 05:09:30.000000000 +0100
@@ -1349,15 +1349,23 @@
     SO_ORIGINAL_DST, SO_ORIGINAL_DST+1, &getorigdst,
     0, NULL };
 
+#ifdef CONFIG_SYSCTL
+
 #define NET_IP_CONNTRACK_MAX 2089
 #define NET_IP_CONNTRACK_MAX_NAME "ip_conntrack_max"
 
-#ifdef CONFIG_SYSCTL
+#define NET_IP_CONNTRACK_HASHSIZE 2090
+#define NET_IP_CONNTRACK_HASHSIZE_NAME "ip_conntrack_hashsize"
+
 static struct ctl_table_header *ip_conntrack_sysctl_header;
 
 static ctl_table ip_conntrack_table[] = {
-	{ NET_IP_CONNTRACK_MAX, NET_IP_CONNTRACK_MAX_NAME, &ip_conntrack_max,
-	  sizeof(ip_conntrack_max), 0644,  NULL, proc_dointvec },
+	{ NET_IP_CONNTRACK_MAX, NET_IP_CONNTRACK_MAX_NAME,
+	  &ip_conntrack_max, sizeof(ip_conntrack_max), 0644,
+	  NULL, proc_dointvec },
+	{ NET_IP_CONNTRACK_HASHSIZE, NET_IP_CONNTRACK_HASHSIZE_NAME,
+	  &ip_conntrack_htable_size, sizeof(ip_conntrack_htable_size), 0444,
+	  NULL, proc_dointvec },
  	{ 0 }
 };
 

--VS++wcV0S1rZb1Fb--
