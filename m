From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [PATCH] Delete nfcache use in ip_table
Date: Thu, 05 May 2005 23:21:52 +0200
Message-ID: <1115328112.3382.2.camel@krak.odu>
References: <427A469D.8030305@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <427A469D.8030305@eurodev.net>
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


  Hi Pablo,

On Thu, 2005-05-05 at 18:15 +0200, Pablo Neira wrote:
> Since we've removed the use of nfcache in iptables, I think that it 
> should be remove in ip_tables.c as well because:
> 
> a) there's no utility on it
> b) it can be source of interferences for the conntrack-event-api, and 
> thus for conntrack_netlink and ct_sync.

  Wow, thanks a lot for this fix. Indeed, it seems this bug might have
been the source of a ct_sync problem experienced by some of the testers.

--
 Regards, 
  Krisztian Kovacs
