From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] NETFILTER: tcp window tracking
Date: Sat, 24 Jul 2004 23:22:39 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724232239.29bd3ee3.davem@redhat.com>
References: <20040724153427.GV2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040724153427.GV2848@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 24 Jul 2004 11:34:27 -0400
Harald Welte <laforge@netfilter.org> wrote:

> This is the tcp window tracking patch, incremental to all previous
> changes.  It is now by default enabled (i.e. in 'conservative' mode).
> If you think it's better to leave it disabled ('liberal' mode), you can
> change ip_conntrack_tcp_be_liberal to a different default value.

All 12 incremental patches applied, plus this window
tracking code.

Three comments:

1) Patch 7, the seq_file patch was slightly busted,
   look at this hunk:

 #ifdef CONFIG_IP_NF_CT_ACCT
 static unsigned int
-print_counters(char *buffer, struct ip_conntrack_counter *counter)
+seq_print_counters(struct seq_file *s, struct ip_conntrack_counter *counter)
 {
-	return sprintf(buffer, "packets=%llu bytes=%llu ", 
-			counter->packets, counter->bytes);
+	return seq_printf(s, "packets=%llu bytes=%llu ",
+			  counter->packets, counter->bytes);
 }
 #else
 #define seq_print_counters(x, y)	0
 #endif
 
   Hehe, last #define line should be something like:

-#define print_counters(x, y)	0
+#define seq_print_counters(x, y)	0

   I fixed that up by hand.

2) ipt_sctp match had double slashes in the path names in
   the diff, that confuses diffstat and thus my automated
   scripts.

3) Yes, I think the new window tracking code mode should
   be on by default.

Thanks a lot Harald.
