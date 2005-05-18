From: Damon Gray <dgray@internap.com>
Subject: EXPORT_SYMBOL(hash_conntrack)
Date: Wed, 18 May 2005 17:47:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0505181743480.16841@dgray-test.acs.internap.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


I have a need to be able to use hash_conntrack in a kernel module. Does 
anyone see a problem if hash_conntrack was exported? I'd prefer to use the 
function instead of duplicating it with jhash_3words just so I don't have 
to keep track of how hash_conntrack does the hashing.

Thanks

-Damon-
