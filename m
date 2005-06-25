From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC][PATCH] kill the fake conntrack
Date: Sat, 25 Jun 2005 15:20:11 +0200
Message-ID: <42BD5A0B.7030804@eurodev.net>
References: <42BD513E.6090306@eurodev.net> <42BD52A7.2090107@trash.net>
	<42BD5829.4030002@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42BD5829.4030002@eurodev.net>
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
> why need to set nfctinfo to 0 in nf_reset? since skb->nfct is NULL 
> nf_reset shouldn't be ever called. 

Well, this isn't true at all. nf_reset can be called even if skb->nfct 
is NULL.

> With the logic I'm proposing, this 
> packet will be handle just like invalid ones, so it will be just ignored.

But I still support this this above, making untracked conntracks look 
ignore can simplify the logic AFAICS.

--
Pablo
