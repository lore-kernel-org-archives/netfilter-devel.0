From: marian stagarescu <marian@ti.com>
Subject: how you use nfnetlink-ctnetlink-0.11.patch
Date: 23 Oct 2002 11:16:36 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1035386196.1736.242.camel@gt4rvnd11.telogy.design.ti.com>
References: <1034286048.25146.40.camel@tux>
	<Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
	<20021012141737.X13233@sunbeam.de.gnumonks.org>
	<1034428150.7595.36.camel@tux> <1034429352.7595.48.camel@tux>
	<20021012163620.C13233@sunbeam.de.gnumonks.org>
	<1034436775.7595.96.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org, jschlst@samba.org
In-Reply-To: <1034436775.7595.96.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

can someone give me some input on this patch: 
stability and how to use it ? 
sometime ago i was looking for a way to flush individual conntrack
entries. i think this patch may let me access conntrack entries and, for
example, set their TTL to 0 so that it can be flushed. but i'm not user
how to use it: does it have a corresponding userland iptables part ?


thanks,
marian
