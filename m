From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Thu, 4 Nov 2004 22:55:13 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411042254020.18136@filer.marasystems.com>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<20041104154355.GA8553@linuxace.com> <418A6D29.60004@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <418A6D29.60004@trash.net>
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

> Ok, I agree it is still useful, but using the inetaddr_notifier gives
> false positives when more than one IP address is added to the interface.

Which is not an environment MASQUERADE is designed for, so it should be 
acceptable.

There is always the fallback to plain SNAT with ctnetlink for cleaning up 
stale connections when needed.

Regards
Henrik
