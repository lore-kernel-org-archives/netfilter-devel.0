From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 01/03]: nf_conntrack: fix helper module unload races
Date: Mon, 18 Jun 2007 14:29:27 +0200
Message-ID: <46767AA7.4040208@trash.net>
References: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>	<20070605133509.10309.45032.sendpatchset@localhost.localdomain>
	<200706091041.l59AfVck028409@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706091041.l59AfVck028409@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> nfct_help(ct) also needs to be protected because of the race between
> nfctnetlink and helper. Sorry, I did not test the following patch because
> I don't have SMP machine.
> 
> You might dislike this.  Other idea is to use call_rcu() in
> nfctnetlink_change_helper(), but I need to study the way to use it more.
> 
> 
> [NETFILTER]: nf_conntrack: Fixes race on changing helper
> 
> nfctnetlink may change the helper assigned to a conntrack and clear
> private area in the conntrack. To fix the race, this exports spin locks
> of helpers and nfctnetlink uses them. Some helpers do not need to grab
> spin lock, because they do not store any state in the private area.
> 
> Other staff does not need to grab spin lock.
> - unhelp() assigns NULL to conntrack, but it does not touch the private
>   area.
> - init_conntrack(), nf_conntrack_alter_reply(), and
>   nfctnetlink_create_conntrack() assign a helper to a conntrack,
>   but the conntrack is unconfirmed. No competitor exists.


The fix looks correct, but considering the other problems that changing
helpers cause for ct_extend I'm wondering whether we could restrict the
helper change operation to conntracks that don't already have a helper
assigned. I can't imagine any use for changing helpers of a connection
that already has one assigned and it will always be racy anyway.
Pablo, are you aware of anything using/needing this feature?
