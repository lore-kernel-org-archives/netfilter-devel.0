From: Bruce Guenter <lists-netfilter-devel@bruce-guenter.dyndns.org>
Subject: Variable-length data?
Date: Wed, 15 Sep 2004 11:18:14 -0600
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040915171814.GA30824@em.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Greetings.

I have written a simple filter for matching multiple network masks in a
list.  From what I can see, the actual netfilter data has to be constant
sized.  Is this true, or is there an easy way to have a non-fixed size
list of addresses (for example)?  It seems rather wasteful to allocate a
large array when only a small one is needed.

Thanks.
-- 
Bruce Guenter <bruceg@em.ca> http://em.ca/~bruceg/ http://untroubled.org/
OpenPGP key: 699980E8 / D0B7 C8DD 365D A395 29DA  2E2A E96F B2DC 6999 80E8
