From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Variable-length data?
Date: Wed, 15 Sep 2004 20:10:10 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409152009120.4567@filer.marasystems.com>
References: <20040915171814.GA30824@em.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bruce Guenter <lists-netfilter-devel@bruce-guenter.dyndns.org>
In-Reply-To: <20040915171814.GA30824@em.ca>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 15 Sep 2004, Bruce Guenter wrote:

> I have written a simple filter for matching multiple network masks in a
> list.  From what I can see, the actual netfilter data has to be constant
> sized.  Is this true, or is there an easy way to have a non-fixed size
> list of addresses (for example)?

iptables matches (and targets) must use a static size matchdata structure 
per match (or target).

> It seems rather wasteful to allocate a large array when only a small one 
> is needed.

It is.

Regards
Henrik
