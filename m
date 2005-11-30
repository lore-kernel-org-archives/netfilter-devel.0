From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RESEND][PATCH] Recent match jiffies wrap mismatches
Date: Wed, 30 Nov 2005 08:20:01 -0800
Message-ID: <20051130162001.GA7120@linuxace.com>
References: <20051129050813.GA30630@linuxace.com> <438CDE4E.8070006@trash.net>
	<20051129235159.GA3680@linuxace.com> <438D5825.2070304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <438D5825.2070304@trash.net>
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

On Wed, Nov 30, 2005 at 08:43:33AM +0100, Patrick McHardy wrote:
> But last_seen is initialized to 0 too. Is there something I'm missing
> that prevents these entries from beeing used?

We only reach this section of code if an existing hash table entry is found,
and when the hash entry is created:

                r_list[location].last_seen = now;

So no - last_seen will not be unitialized.

Phil
