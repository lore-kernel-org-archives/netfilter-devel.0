From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] kill the fake conntrack
Date: Sat, 25 Jun 2005 14:48:39 +0200
Message-ID: <42BD52A7.2090107@trash.net>
References: <42BD513E.6090306@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42BD513E.6090306@eurodev.net>
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

Pablo Neira wrote:
> The patch attached kills the fake conntrack and propose a new logic to
> explicitely set connection as untracked. We set nfct to NULL and use a
> new flag called IP_CT_UNTRACKED for nfctinfo. I've slightely tested it
> here and works fine.
> 
> Comments welcome.

What is the advantage of this patch? Its changing the assumption
that skb->nfctinfo is only valid if skb->nfct is set, so you probably
need to set nfctinfo to 0 in nf_reset as well. This alone is a reason
not to do it IMO.

Regards
Patrick
