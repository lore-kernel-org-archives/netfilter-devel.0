From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] port physdev to ip6tables
Date: Mon, 13 Sep 2004 01:17:14 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4144D8FA.2040903@trash.net>
References: <200409111259.28468.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200409111259.28468.bdschuym@pandora.be>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Bart De Schuymer wrote:

>Hi,
>
>Attached are 2 patches, one against kernel 2.6.8.1 and the other against the 
>iptables userspace CVS. They add the physdev module to ip6tables. The physdev 
>module is quite essential for people wanting to filter bridged IPv6 frames.
>
Thanks, I've applied the userspace patch and will send the kernel patch
to Dave soon.

Regards
Patrick

>
>cheers,
>Bart
>  
>
