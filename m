From: Thomas Graf <tgraf@suug.ch>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Mon, 3 Jan 2005 00:57:57 +0100
Message-ID: <20050102235757.GA26856@postel.suug.ch>
References: <41D86571.6070501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
	Jamal Hadi Salim <hadi@cyberus.ca>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41D86571.6070501@trash.net>
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

* Patrick McHardy <41D86571.6070501@trash.net> 2005-01-02 22:19
> skb_ip_make_writable copies the packet as soon as the data area needs
> to be touched. This is of course necessary for packets generated locally,
> but can't we mangle the data area of skbs with skb->sk == NULL without
> copying them ?

Theoretically there could be a driver for a S/G capable nic producing
pskbs. I'm not aware of such a driver though. Assuming there is no
such driver at the moment, the question is whether to make all the
paths aware as a precaution (net/sched/ is not aware as of now). I
think everyone would agree if there wasn't such ia high possible
performance impact respectively saving. Thoughts?
