From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug (?) in ipt_reject doesn't follow policy routing (2.4.x)
Date: Mon, 14 Apr 2003 23:09:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9B2398.8020109@trash.net>
References: <Pine.LNX.4.21.0304141317090.763-100000@debian.besselink>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000404050408090103000307"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: leen@wirehub.nl
In-Reply-To: <Pine.LNX.4.21.0304141317090.763-100000@debian.besselink>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000404050408090103000307
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Leen,

Leen Besselink wrote:

>It's a safety messure, maybe because they are afraid of loops...? And
>because it touches/triggers other things, like NAT, so it seems, when I
>look at the code.
>  
>
"dumb nat" is also triggered in ip_route_output, loops should not occur 
because
ipt_REJECT gives packets directly to ip_route_output2. a reason might be 
ip_route_input
doing policy checks, namely it checks if forwarding is configured on the 
receiving interface.

>You have a firewall-rule of which an incoming packet would trigger a new
>packet, which might trigger a firewall-rule to trigger an other packet...
>etc. But maybe I'm wrong, I'm not familair with the code (yet ?).
>

i've attached a patch which uses ip_route_input for tcp_resets in 
ipt_REJECT.
would you care to test it ? i confirmed it rejects correctly without 
policy routing,
but i have a very simple setup here so no good testing ..
The patch adds a call to ip_route_input after the ip_route_output for 
non-local
sources. The call to ip_route_output is still necesarry so we know an 
interface
where the source ip may actually have entered, otherwise it would only work
with reverse-path filters turned off.

@netfilter-people: would something like this be acceptable ? REJECT and 
MIRROR
(which looks broken wrt ip_route_output and dst handling) need something
like this to work correctly with policy routing.

Bye
Patrick


--------------000404050408090103000307
Content-Type: text/plain;
 name="ipt_REJECT-tcprst-route.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_REJECT-tcprst-route.diff"

===== ipt_REJECT.c 1.10 vs edited =====
--- 1.10/net/ipv4/netfilter/ipt_REJECT.c	Mon Mar 31 17:00:55 2003
+++ edited/ipt_REJECT.c	Mon Apr 14 23:00:54 2003
@@ -66,11 +66,26 @@
 
 	/* Routing: if not headed for us, route won't like source */
 	if (ip_route_output(&rt, oldskb->nh.iph->daddr,
-			    local ? oldskb->nh.iph->saddr : 0,
-			    RT_TOS(oldskb->nh.iph->tos) | RTO_CONN,
-			    0) != 0)
+	                    local ? oldskb->nh.iph->saddr : 0,
+	                    RT_TOS(oldskb->nh.iph->tos), 0) != 0)
 		return;
 
+	/* if src is not local use ip_route_input to respect policy routing
+	 * decision. the call to ip_route_output is still necessary so we
+	 * have a interface where the ip may actually have entered.
+	 */
+	if (local == 0) {
+		struct dst_entry *out_dst = (struct dst_entry *)rt;
+		if (ip_route_input(oldskb, oldskb->nh.iph->saddr,
+		                  oldskb->nh.iph->daddr,
+		                  RT_TOS(oldskb->nh.iph->tos),
+                                  out_dst->dev) != 0)
+			return;
+		dst_release(out_dst);
+		rt = (struct rtable *)oldskb->dst;
+		dst_hold(&rt->u.dst);
+	}
+	
 	hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;
 
 

--------------000404050408090103000307--
