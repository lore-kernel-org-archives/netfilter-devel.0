From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Mon, 8 Nov 2004 02:17:47 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411080215020.8242@filer.marasystems.com>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <418999B2.3070600@trash.net>
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

On Thu, 4 Nov 2004, Patrick McHardy wrote:

> I think we should revert to the old behaviour for all interfaces.
> When MASQUERADE was using a route-lookup for selecting the source
> there were good reasons for using MASQUERADE on devices with statically
> configured adresses, and some people (like me) still do it today.

If this is what you want create another "Automatic SNAT" target without 
the flush logics.

Presonally my opinion is that SNAT does the job just fine in static 
configurations, but I can imagine a few complex multilink setups where 
automatic selection of the SNAT IP may be preferable.

Regards
Henrik
