From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix hang on netfilter module unload
Date: Tue, 15 Mar 2005 20:53:57 +0100
Message-ID: <42373D55.8020005@trash.net>
References: <20050315050641.GA334@linuxace.com>
	<20050315172330.GA3130@linuxace.com> <4237369D.8080408@trash.net>
	<20050315194602.GA3487@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030906090804000707000408"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050315194602.GA3487@linuxace.com>
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
--------------030906090804000707000408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Phil Oester wrote:
> On a box with modular iptables, a DHCP interface, and NetworkManager
> set to run on boot:

What is NetworkManager? Can I download the source somewhere?

> 1) boot box
> 2) verify ip_conntrack_count and wc -l /proc/net/ip_conntrack are both 0
> 3) NetworkManager stop
> 4) ifdown eth0
> 5) NetworkManager start
> 
> NM seems to never release the reference to at least one of its
> conntracks (sometimes more than one).  At this point, a conntrack
> has been cleaned from lists but not destroyed, and the counts
> shown in #2 will not match.  
> 
> It seems to me we should still track conntracks which are cleaned
> but not yet destroyed, no?  Isn't it possible for a malicious
> app to screw us here by intentionally getting the counts out of
> whack?

I don't think it is related to the specific application.
More likely the packet is queued while the device is down
and never dequeued. Does this patch fix the problem ?

Regards
Patrick

--------------030906090804000707000408
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/core/dev.c 1.184 vs edited =====
--- 1.184/net/core/dev.c	2005-02-09 01:20:02 +01:00
+++ edited/net/core/dev.c	2005-03-15 20:53:16 +01:00
@@ -1246,6 +1246,9 @@
 	      	if (skb_checksum_help(skb, 0))
 	      		goto out_kfree_skb;
 
+	nf_conntrack_put(skb->nfct);
+	skb->nfct = NULL;
+
 	/* Disable soft irqs for various locks below. Also 
 	 * stops preemption for RCU. 
 	 */

--------------030906090804000707000408--
