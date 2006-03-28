From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip_conntrack_netlink : fix expectation
	notifier	unregistration
Date: Tue, 28 Mar 2006 15:28:48 +0200
Message-ID: <44293A10.6060301@trash.net>
References: <1143382791.4015.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1143382791.4015.21.camel@localhost.localdomain>
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

Martin Josefsson wrote:
> Same fix as for the notifier unregistration bug in nf_conntrack_netlink.
> 
> This patch fixes expectation notifier unregistration on module unload to
> use ip_conntrack_expect_unregister_notifier(). This bug causes a soft
> lockup at the first expectation created after a rmmod ; insmod of this
> module.
> 
> Should go into -stable as well.

Applied to my tree, I'll pass them on soon (probably tonight).
