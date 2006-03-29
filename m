From: Patrick McHardy <kaber@trash.net>
Subject: Re: Two comments on the H.323 conntrack/NAT helper
Date: Wed, 29 Mar 2006 12:09:23 +0200
Message-ID: <442A5CD3.3060401@trash.net>
References: <20060324001307.GO22727@stusta.de> <44235324.3080607@trash.net>
	<BAY109-DAV2BB627B948B4A363C4436B3DF0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, zhaojingmin@users.sourceforge.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV2BB627B948B4A363C4436B3DF0@phx.gbl>
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
> I've moved those prototypes. But the move involves moving of two header
> files:
> ip_conntrack_helper_h323_asn1.h and ip_conntrack_helper_h323_types.h.
> This is because ip_conntrack_h323.h now has to include
> ip_conntrack_helper_h323_asn1.h and thus ip_conntrack_helper_h323_types.h,
> so they are moved from net/ipv4/netfilter/ to
> include/linux/netfilter_ipv4/ to
> make sure other header files like ip_conntrack_h323.h and ip_conntrack.h
> be able to find them.
> 
> Is this ok or you have a better idea?

I can't think of a better solution as long as we have the typedefs.
