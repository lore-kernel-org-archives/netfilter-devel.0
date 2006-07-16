From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] BUG: libiptc chain references bug
Date: Sun, 16 Jul 2006 17:01:53 +0200
Message-ID: <44BA54E1.1000908@netfilter.org>
References: <Pine.LNX.4.61.0607121722360.13610@ask.diku.dk>	<Pine.LNX.4.61.0607131303220.29013@tyr.diku.dk>
	<Pine.LNX.4.61.0607141427230.31153@tyr.diku.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050709010700000304050009"
Cc: hawk@comx.dk, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
In-Reply-To: <Pine.LNX.4.61.0607141427230.31153@tyr.diku.dk>
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
--------------050709010700000304050009
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jesper,

Jesper Dangaard Brouer wrote:
> 
> Correcting a chain references increment bug in libiptc.
> 
> The bug lies in function iptc_delete_entry() / TC_DELETE_ENTRY.  The
> problem is the construction of "r" the rule entry, that is used for
> comparison. The problem is that the function iptcc_map_target()
> increase the target chains references count.
> 
> The fix is to use function iptcc_delete_rule() to delete the "r" rule
> (as it decrement the counter again). To make it work a small NULL
> pointer check is also added iptcc_delete_rule().
> 
> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>

I don't like too much the is-the-rule-in-list checking in delete_entry, 
please, could you tell me what you think about the patch attached? I 
think it's cleaner. Thanks.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------050709010700000304050009
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Based on Jesper Dangaard Brouer's patch.

Index: libiptc/libiptc.c
===================================================================
--- libiptc/libiptc.c	(revisión: 6644)
+++ libiptc/libiptc.c	(copia de trabajo)
@@ -1543,6 +1543,14 @@
 		c->num_rules--;
 		iptcc_delete_rule(i);
 
+		/* Since iptcc_map_target increments refcounting of
+		 * the target chain used by the fake rule, once we
+		 * have matched it against the real rule, do not forget
+		 * to drop the refcount that the fake rule holds */
+		if (r->type == IPTCC_R_JUMP
+		    && r->jump)
+			r->jump->references--;
+
 		set_changed(*handle);
 		free(r);
 		return 1;

--------------050709010700000304050009--
