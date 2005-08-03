From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack port of conntrack-event-api
Date: Wed, 03 Aug 2005 23:50:01 +0200
Message-ID: <42F13C09.6090106@trash.net>
References: <20050803213816.GA3819@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050803213816.GA3819@rama.de.gnumonks.org>
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

Harald Welte wrote:
> Hi! I've just committed the following patch to the nf_conntrack branch
> of my netfilter-2.6.14 tree:
> 
> [NETFILTER] port conntrack-events from ip_conntrack to nf_conntrack
> 
> This adds a notifier chain based event mechanism for nf_conntrack state
> changes.  As opposed to the previous implementations in patch-o-matic, we
> do no longer need a field in the skb to achieve this.

The event cache also needs the fixes I sent in the "atomic counter
underflow" thread two hours ago.

Regards
Patrick
