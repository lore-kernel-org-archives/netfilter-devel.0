From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Sun, 26 Oct 2003 17:19:38 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031026063626.D0FCE2C04B@lists.samba.org>
References: <3F97B874.CB12C184@fy.chalmers.se>
Cc: Harald Welte <laforge@netfilter.org>, coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	davem@redhat.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Polyakov <appro@fy.chalmers.se>
In-reply-to: Your message of "Thu, 23 Oct 2003 13:16:04 +0200."
             <3F97B874.CB12C184@fy.chalmers.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <3F97B874.CB12C184@fy.chalmers.se> you write:
> It's perfectly reproducible with eth0:1. In other words I

Thanks for the excellent help Andy!

Found it by inspection from Andy's description.

We updated ip_nat_setup_info to set the initialized flag and call
place_in_hashes, but *didn't* change the call in ip_fw_compat_masq.c
which also calls place_in_hashes() itself (again!).  Result: corrupt
list, and next thing which lands in the same hash bucket goes boom.

This should fix it.
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.

Name: ipchains/ipfwadm compat changes for new ip_nat_setup_info
Author: Rusty Russell
Status: Experimental

D: We updated ip_nat_setup_info to set the initialized flag and call
D: place_in_hashes, but *didn't* change the call in ip_fw_compat_masq.c
D: which also calls place_in_hashes() itself (again!).  Result: corrupt
D: list, and next thing which lands in the same hash bucket goes boom.
D: 
D: Thanks to Andy Polyakov for chasing this down.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .17896-linux-2.6.0-test9/net/ipv4/netfilter/ip_fw_compat_masq.c .17896-linux-2.6.0-test9.updated/net/ipv4/netfilter/ip_fw_compat_masq.c
--- .17896-linux-2.6.0-test9/net/ipv4/netfilter/ip_fw_compat_masq.c	2003-09-22 10:28:14.000000000 +1000
+++ .17896-linux-2.6.0-test9.updated/net/ipv4/netfilter/ip_fw_compat_masq.c	2003-10-26 17:17:30.000000000 +1100
@@ -91,9 +91,6 @@ do_masquerade(struct sk_buff **pskb, con
 			WRITE_UNLOCK(&ip_nat_lock);
 			return ret;
 		}
-
-		place_in_hashes(ct, info);
-		info->initialized = 1;
 	} else
 		DEBUGP("Masquerading already done on this conn.\n");
 	WRITE_UNLOCK(&ip_nat_lock);
