From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libiptc symbols clash
Date: Mon, 03 Jul 2006 19:57:09 +0200
Message-ID: <44A95A75.4050205@trash.net>
References: <20060630211248.GB9243@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060630211248.GB9243@linuxace.com>
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
> As reported by Dmitry Levin, the TC_NUM_RULES and TC_GET_RULE exports
> clash.  His patch below, resolving bug #456

What does clash mean in this context? They both end up in different
binaries, so I think I might be misunderstanding you.
