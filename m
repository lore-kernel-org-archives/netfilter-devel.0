From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix format specifier for netfilter log targets
Date: Mon, 15 May 2006 13:40:12 +0200
Message-ID: <4468689C.4000307@trash.net>
References: <44684220.9050107@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <44684220.9050107@snapgear.com>
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

Philip Craig wrote:
> The prefix argument for nf_log_packet is a format specifier,
> so don't pass the user defined string directly to it.

This part is going to get removed again, but for now it seems
reasonable anyway. Thanks.
