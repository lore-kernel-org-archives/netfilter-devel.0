From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Mon, 8 Nov 2004 13:55:25 -0800
Message-ID: <20041108215525.GA8766@linuxace.com>
References: <20041107181825.GA3522@linuxace.com> <418F9952.5030004@trash.net>
	<20041108161511.GA6754@linuxace.com> <418F9DD4.20202@trash.net>
	<20041108163457.GB6754@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <20041108163457.GB6754@linuxace.com>
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

On Mon, Nov 08, 2004 at 08:34:57AM -0800, Phil Oester wrote:
> It's a great idea, and will reduce the size of struct ip_conntrack.
> But I think it should be done in a separate cleanup patch - really would
> like to get this one merged up to fix the masq issues.

Actually masq_index is still used in connect_unassure, and thus can't
be removed completely.  In cases where the interface goes down permanently,
clearing the assured bit makes sense, so guess this behaviour should be
maintained.

Phil
