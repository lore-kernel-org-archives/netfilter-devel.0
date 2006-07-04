From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] libiptc symbols clash
Date: Tue, 4 Jul 2006 08:27:37 -0700
Message-ID: <20060704152737.GA8518@linuxace.com>
References: <20060630211248.GB9243@linuxace.com> <44A95A75.4050205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44A95A75.4050205@trash.net>
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

On Mon, Jul 03, 2006 at 07:57:09PM +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> > As reported by Dmitry Levin, the TC_NUM_RULES and TC_GET_RULE exports
> > clash.  His patch below, resolving bug #456
> 
> What does clash mean in this context? They both end up in different
> binaries, so I think I might be misunderstanding you.

They end up in libiptc.a twice:

# readelf -s libiptc.a | grep TC
    56: 00000b70    81 FUNC    GLOBAL DEFAULT    1 TC_GET_RULE
    57: 00000bd0    56 FUNC    GLOBAL DEFAULT    1 TC_NUM_RULES
    57: 00000c10    81 FUNC    GLOBAL DEFAULT    1 TC_GET_RULE
    58: 00000c70    56 FUNC    GLOBAL DEFAULT    1 TC_NUM_RULES

instead of with the standard iptc_ and ip6tc_ naming.

Phil
