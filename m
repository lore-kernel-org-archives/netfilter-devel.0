From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] Netfilter: Remove ip_conntrack_tuple_hash "ctrack"
Date: Tue, 25 Jan 2005 18:46:33 +1100
Message-ID: <1106639193.19186.50.camel@localhost.localdomain>
References: <1105444254.19331.43.camel@localhost.localdomain>
	<m3k6q52ubw.fsf@igel.m5r.de>
	<1106535381.19666.6.camel@localhost.localdomain>
	<jellajqguc.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andreas Schwab <schwab@suse.de>
In-Reply-To: <jellajqguc.fsf@sykes.suse.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2005-01-24 at 11:08 +0100, Andreas Schwab wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> 
> > On Sat, 2005-01-22 at 19:26 +0100, Andreas Schwab wrote:
> >> Doesn't this break the iptables conntrack module on big-endian systems?
> >
> > I don't see why... we only need 8 bits for the protocol, and we used to
> > use 16 (because we had them).  I wanted to add a field, so I reduced
> > protonum to 8 bits and added another 8 bit field.
> 
> iptables uses this structure internally.  If it also uses it inside a
> kernel interface then you have broken the kernel ABI.

Sorry, I misunderstood.  You're right.

Name: Avoid breaking userspace due to tuple change
Status: Trivial, Compiled
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Andreas Schwab <schwab@suse.de> points out that the ipt_conntrack
match exposes "struct ip_conntrack_tuple" to userspace, and we changed
it recently.  Make it use a "special" one, to avoid breaking
compatibility.

Index: linux-2.6.11-rc2-bk2-Netfilter/include/linux/netfilter_ipv4/ipt_conntrack.h
===================================================================
--- linux-2.6.11-rc2-bk2-Netfilter.orig/include/linux/netfilter_ipv4/ipt_conntrack.h	2005-01-11 14:21:11.000000000 +1100
+++ linux-2.6.11-rc2-bk2-Netfilter/include/linux/netfilter_ipv4/ipt_conntrack.h	2005-01-25 18:22:29.588143064 +1100
@@ -22,11 +22,32 @@
 #define IPT_CONNTRACK_STATUS	0x40
 #define IPT_CONNTRACK_EXPIRES	0x80
 
+/* This is exposed to userspace, so remains frozen in time. */
+struct ip_conntrack_old_tuple
+{
+	struct {
+		__u32 ip;
+		union {
+			__u16 all;
+		} u;
+	} src;
+
+	struct {
+		__u32 ip;
+		union {
+			__u16 all;
+		} u;
+
+		/* The protocol. */
+		u16 protonum;
+	} dst;
+};
+
 struct ipt_conntrack_info
 {
 	unsigned int statemask, statusmask;
 
-	struct ip_conntrack_tuple tuple[IP_CT_DIR_MAX];
+	struct ip_conntrack_old_tuple tuple[IP_CT_DIR_MAX];
 	struct in_addr sipmsk[IP_CT_DIR_MAX], dipmsk[IP_CT_DIR_MAX];
 
 	unsigned long expires_min, expires_max;

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
