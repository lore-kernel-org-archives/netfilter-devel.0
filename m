From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: EXPORT_SYMBOL vs EXPORT_SYMBOL_GPL
Date: Tue, 23 May 2006 08:49:40 +0900 (JST)
Message-ID: <200605222349.k4MNnfib029516@toshiba.co.jp>
References: <4471E053.2090601@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4471E053.2090601@trash.net>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 22 May 2006 18:01:23 +0200

> Hi Yasuyuki,
> 
> while doing some stupid cleanup work on the conntrack code (moving
> all EXPORT_SYMBOLs next to the exported function) I noticed
> nf_conntrack uses EXPORT_SYMBOL for the exact same functions that
> are EXPORT_SYMBOL_GPL'ed by ip_conntrack. I think we should change
> it to _GPL too for consistency and because most of them mess deeply
> inside the internals of conntrack.
> 
> Any objections to this change?

No objection, thanks for this cleanup.

-- Yasuyuki Kozakai
