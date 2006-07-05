From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libiptc symbols clash
Date: Wed, 05 Jul 2006 11:06:11 +0200
Message-ID: <44AB8103.5070002@trash.net>
References: <20060630211248.GB9243@linuxace.com> <44A95A75.4050205@trash.net>
	<20060704152737.GA8518@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060704152737.GA8518@linuxace.com>
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

Phil Oester wrote:
> On Mon, Jul 03, 2006 at 07:57:09PM +0200, Patrick McHardy wrote:
> 
>>Phil Oester wrote:
>>
>>>As reported by Dmitry Levin, the TC_NUM_RULES and TC_GET_RULE exports
>>>clash.  His patch below, resolving bug #456
>>
>>What does clash mean in this context? They both end up in different
>>binaries, so I think I might be misunderstanding you.
> 
> 
> They end up in libiptc.a twice:
> 
> # readelf -s libiptc.a | grep TC
>     56: 00000b70    81 FUNC    GLOBAL DEFAULT    1 TC_GET_RULE
>     57: 00000bd0    56 FUNC    GLOBAL DEFAULT    1 TC_NUM_RULES
>     57: 00000c10    81 FUNC    GLOBAL DEFAULT    1 TC_GET_RULE
>     58: 00000c70    56 FUNC    GLOBAL DEFAULT    1 TC_NUM_RULES
> 
> instead of with the standard iptc_ and ip6tc_ naming.

I wonder why nothing seems to complain about this.
Applied, thanks.
