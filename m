From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipset patch-o-matic-ng-20070524.tar.bz2 doesn't work on SuSE
 10.3	Beta2 kernel (2.6.22.3-7-bigsmp)
Date: Wed, 29 Aug 2007 18:59:20 +0200
Message-ID: <46D5A5E8.3020004@trash.net>
References: <D0B3C45E7FCE4C488BEF410B2EF666A10187D21A@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Hung Lin <hlin@nextone.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <D0B3C45E7FCE4C488BEF410B2EF666A10187D21A@moe.nextone.local>
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

Hung Lin wrote:
> Hi,
> 
> I tried to use ipset patch-o-matic-ng to patch SuSE 10.3 Beta2 kernel but it doesn't work.  Here's the commands I run:
> 
> suse10-3:/usr/src/patch-o-matic-ng # KERNEL_DIR=/usr/src/linux-2.6.22.3-7 IPTABLES_DIR=/usr/src/iptables/ ./runme pending
> Loading patchlet definitions................. done
> 
> 
> Excellent! Source trees are ready for compilation.
> 
> suse10-3:/usr/src/patch-o-matic-ng #
> suse10-3:/usr/src/patch-o-matic-ng #
> 
> 
> It showed source trees are ready for compilation, but the source tree doesn't be changed at all.


There are no "pending" patches in pom anymore.
