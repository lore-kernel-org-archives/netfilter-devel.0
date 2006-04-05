From: Patrick McHardy <kaber@trash.net>
Subject: Re: H.323 conntrack/NAT helper update for 2.6.17-rc1
Date: Wed, 05 Apr 2006 19:10:23 +0200
Message-ID: <4433F9FF.6050709@trash.net>
References: <BAY109-DAV15AA944ABA789908271E35B3CB0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV15AA944ABA789908271E35B3CB0@phx.gbl>
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

Jing Min Zhao wrote:
> Hi, Patrick,
> 
> This patch is to update 2.6.17-rc1 to the latest state. It includes
> following changes that are not in 2.6.17-rc1:
> 
> 1. Add new parameter 'default_rrq_ttl'.
> 2. Change get_h245_addr to static
> 3. Change to use EXPORT_SYMBOL_GPL
> 4. Move some extern function prototypes from ip_nat_helper_h323.c    to
> ip_conntrack_h323.h.
> 5. Move ip_conntrack_helper_h323_asn1.h and   
> ip_conntrack_helper_h323_types.h from net/ipv4/netfilter/ to   
> include/linux/netfilter_ipv4/.
> 
> Please have a look at it and apply it.

Applied, thanks. A couple of comments though:

- I've split your patches into the logical changes, this is prefered
  to "version-updates". Ideally you just send one patch per change.

- whitespace changes:

-               /* ip_nat_mangle_udp_packet uses skb_make_writable() to copy
-                * or pull everything in a linear buffer, so we can safely
+               /* ip_nat_mangle_udp_packet uses skb_make_writable() to
copy
+                * or pull everything in a linear buffer, so we can safely

Please try to avoid such things, except for seperated patches that
_remove_ whitespace :)

- I've changed default_rrq_timeout to unsigned because it is assigned
  to an unsigned member.

- Changelogs in the source-code: its your choice, but I personally
  prefer to avoid changelogs in the source files, they tend to
  grow pretty fast and you are mostly not interested in them. If
  you are, you can use the git history.

Thanks again.
