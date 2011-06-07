From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [RFC] SLOB breaks netfilter
Date: Tue, 7 Jun 2011 23:06:51 +0200
Message-ID: <20110607210651.GA11159@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, tglx@linutronix.de
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I've been wondering why the internet was sometimes not working after a
router reboot. Later I noticed that the -j MASQUERADE target in the nat
table was missing. While debugging the serial less router I noticed that
even simple commands like 

|~# iptables -nvL -t nat
|iptables v1.4.2: can't initialize iptables table `nat': Table does not
|exist (do you need to insmod?)
|Perhaps iptables or your kernel needs to be upgraded.

were failing sometimes. Not always, sometimes. Once the module was
loaded, it seems to work.
After more debugging I found the root cause: In
check_entry_size_and_hooks() I see:
              if ((unsigned long)e % __alignof__(struct arpt_entry) != 0 ||

and SLOB defines:

|#ifdef ARCH_DMA_MINALIGN
|#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
|#else
|#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
|#endif
| 
|#ifndef ARCH_SLAB_MINALIGN
|#define ARCH_SLAB_MINALIGN __alignof__(unsigned long)
|#endif

Using u64 instead solved the problem. So my question is this check
really required?
The following patch fixes the nat problem. One thing that still fails
(with the patch but works with alignof (u64)) is

|~# ip6tables -P INPUT DROP
|ip6tables v1.4.2: can't initialize ip6tables table `filter': Table does
|not exist (do you need to insmod?)
|Perhaps ip6tables or your kernel needs to be upgraded.

but I need to sleep now.

---
 net/ipv4/netfilter/arp_tables.c |    3 +--
 net/ipv4/netfilter/ip_tables.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 89bc7e6..577ca67 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -559,8 +559,7 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 {
 	unsigned int h;
 
-	if ((unsigned long)e % __alignof__(struct arpt_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct arpt_entry) >= limit) {
+	if ((unsigned char *)e + sizeof(struct arpt_entry) >= limit) {
 		duprintf("Bad offset %p\n", e);
 		return -EINVAL;
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7049150..fb0f2ce 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -731,8 +731,7 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 {
 	unsigned int h;
 
-	if ((unsigned long)e % __alignof__(struct ipt_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct ipt_entry) >= limit) {
+	if ((unsigned char *)e + sizeof(struct ipt_entry) >= limit) {
 		duprintf("Bad offset %p\n", e);
 		return -EINVAL;
 	}
-- 
1.7.4.4

Sebastian
