From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix for rtsp helper
Date: Mon, 19 Apr 2004 14:02:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4083BFF3.2010201@trash.net>
References: <20040418150948.GA24110@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,  tmarshall@real.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <w@w.ods.org>
In-Reply-To: <20040418150948.GA24110@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Willy Tarreau wrote:
> Hi,
> 
> I noticed that the rtsp helper puts the 'master' info in the expect table
> in ip_conntrack.h. Here's the little fix against latest pom-ng :

Applied, thanks Willy.

Regards
Patrick


> 
> Cheers,
> Willy
> 
> --- ./rtsp-conntrack/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd.orig	Sun Apr 18 17:05:13 2004
> +++ ./rtsp-conntrack/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd	Sun Apr 18 17:05:22 2004
> @@ -1,2 +1,2 @@
> -	/* insert conntrack helper private data (expect) here */
> +	/* insert conntrack helper private data (master) here */
>  	struct ip_ct_rtsp_master ct_rtsp_info;
> 
> 
