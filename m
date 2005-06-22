From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Linux 2.6.12/iptables 1.3.1+CLUSTERIP issues
Date: Wed, 22 Jun 2005 23:05:29 +0200
Message-ID: <42B9D299.1080902@eurodev.net>
References: <876ef97a0506201904a05582a@mail.gmail.com>
	<20050622121509.GG4551@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000302090108050508090106"
Cc: Tobias DiPasquale <codeslinger@gmail.com>,
	nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050622121509.GG4551@obroa-skai.de.gnumonks.org>
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

This is a multi-part message in MIME format.
--------------000302090108050508090106
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

Harald Welte wrote:
>>2. I installed this rule just to test things out:
>>
>>iptables -A INPUT -d 192.168.1.3 -i eth0 -p tcp --dport 3000 -j
>>CLUSTERIP --new --hashmode sourceip-sourceport --clustermac
>>01:23:45:67:89:AB --total-nodes 2 --local-node 1
>>
>>I then tried to remove it (I didn't update iptables rules again since
>>then) by switching the -A to a -D and that failed. I tried all sorts
>>of combinations of the arguments to -j CLUSTERIP but they all failed.
>>Eventually, I was forced to remove the rule by using the iptables rule
>># (e.g. iptables -D INPUT 10). I feel that this is in error, but I've
>>seen at least two patches to CLUSTERIP that claim to fix rule
>>deletion. Am I doing something wrong?

fix-del-with-userspacesize-target.patch:

You still need to apply this patch to iptables, it got lost somehow 
since I've posted it some time ago. It fixes ipt_CLUSTERIP deletion. To 
be precise, it fixes rule deletion of targets whose userspace size part 
differs from the kernel part.

BTW, I forgot if you passed the patch here below (link) to davem? I 
can't see it in the current git snapshot. got lost as well ?

http://people.netfilter.org/pablo/patches/fixes/kernel/pending/fix-layout-CLUSTERIP.patch

@Tobias: With both patches applied you'll fix your problems with 
CLUSTERIP rule deletion.

--
Pablo

--------------000302090108050508090106
Content-Type: text/x-patch;
 name="fix-del-with-userspacesize-target.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="fix-del-with-userspacesize-target.patch"

Index: libiptc/libip4tc.c
===================================================================
--- libiptc/libip4tc.c	(revision 3742)
+++ libiptc/libip4tc.c	(working copy)
@@ -210,6 +210,7 @@
 	mptr = matchmask + sizeof(STRUCT_ENTRY);
 	if (IPT_MATCH_ITERATE(a, match_different, a->elems, b->elems, &mptr))
 		return NULL;
+	mptr += IPT_ALIGN(sizeof(struct ipt_entry_target));
 
 	return mptr;
 }
Index: libiptc/libip6tc.c
===================================================================
--- libiptc/libip6tc.c	(revision 3742)
+++ libiptc/libip6tc.c	(working copy)
@@ -242,6 +242,7 @@
 	mptr = matchmask + sizeof(STRUCT_ENTRY);
 	if (IP6T_MATCH_ITERATE(a, match_different, a->elems, b->elems, &mptr))
 		return NULL;
+	mptr += IP6T_ALIGN(sizeof(struct ip6t_entry_target));
 
 	return mptr;
 }

--------------000302090108050508090106--
