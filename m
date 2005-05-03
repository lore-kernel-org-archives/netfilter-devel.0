From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] conntrack-mms / gcc4 fix.
Date: Tue, 03 May 2005 20:01:07 +0200
Message-ID: <4277BC63.9010000@trash.net>
References: <200504282149.08554.pluto@pld-linux.org>
	<4271707A.5060603@trash.net>
	<200505030922.34134.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@pld-linux.org>
In-Reply-To: <200505030922.34134.pluto@pld-linux.org>
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

Pawel Sikora wrote:
> Hi All,
> 
> During build with gcc4 I get:
> 
>   CC [M]  net/ipv4/netfilter/ip_conntrack_mms.o
>           net/ipv4/netfilter/ip_conntrack_mms.c:55:
>   error: static declaration of 'ip_nat_mms_hook'
>   follows non-static declaration
>   include/linux/netfilter_ipv4/ip_conntrack_mms.h:37:
>   error: previous declaration of 'ip_nat_mms_hook' was here
> 
> Attached patch fixes it and should be applied.

Done, thanks Pawel.

Regards
Patrick
