From: Patrick McHardy <kaber@trash.net>
Subject: Re: [H.323 Helper 1/3]: Add support for Call Forwarding
Date: Wed, 26 Apr 2006 15:48:47 +0200
Message-ID: <444F7A3F.9080507@trash.net>
References: <BAY109-DAV265AE2E1870989462F689B3BE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV265AE2E1870989462F689B3BE0@phx.gbl>
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
> This patch is for 2.6.17-rc2. Please visit
> http://nath323.sourceforge.net/#_Toc133598071 for details.
> 
> Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.net>

Please attach patches inline so I can view and quote them in my mail
client and include the patch description with the patch.

As for the patch:

I definitely don't like the internal_net module option. I know its not
strictly required, more an optimization, but still limiting this to only
one network is not a good idea. We may be able to use the routing
information as indication whether we need an expectation or not .. but
I need think about it some more.


--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -154,6 +154,7 @@ struct ip_conntrack_expect
        unsigned int flags;

 #ifdef CONFIG_IP_NF_NAT_NEEDED
+       u_int32_t saved_ip;
        /* This is the original per-proto part, used to map the
         * expected connection the way the recipient expects. */
        union ip_conntrack_manip_proto saved_proto;

Please explain why this is needed.
