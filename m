From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Thu, 11 Nov 2004 14:58:38 -0800
Message-ID: <20041111145838.6bdb40ce.davem@davemloft.net>
References: <20041107181825.GA3522@linuxace.com>
	<20041108135025.GF12437@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041108135025.GF12437@sunbeam.de.gnumonks.org>
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

On Mon, 8 Nov 2004 14:50:25 +0100
Harald Welte <laforge@netfilter.org> wrote:

> Dave: would the two changes below be acceptable for you?
> 
> > 1) export inet_confirm_addr

This one I think is OK.

> > 2) change inet_ifa_match to use ifa_local instead of ifa_address.
> >    Since ifa_local != ifa_address on ppp interfaces, inet_ifa_match
> >    could not be used to verify ppp interface addresses without
> >    this change.

This one on the other hand is a serious semantic change
and needs more careful thought.  ifa_address is used for
a reason, and people expecting that are going to break
if we change things this way.

A study of at least the net/ipv4/devinet.c shows that this
ifa_address vs. ifa_local distinction is definitely on
purpose.  I really don't think we can make this suggested
change therefore.
