From: Damon Gray <dgray@internap.com>
Subject: ip_conntrack_get doesn't call nf_conntrack_get(&ct->ct_general)
Date: Thu, 1 Sep 2005 15:43:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0509011526550.14997@dgray-test.acs.internap.com>
References: <006101c5af27$2087e750$dd8069d8@html>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <006101c5af27$2087e750$dd8069d8@html>
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


Until I looked more closely I always assumed ip_conntrack_get was doing 
the proper reference counting, and I would always call ip_conntrack_put 
for everything I was "getting". The problem is that ip_conntrack_put calls
nf_conntrack_put(&ct->ct_general) but ip_conntrack_get *does not* call 
nf_conntrack_get(&ct->ct_general). Problem? If so I would be happy to send 
a patch.

Thanks

-Damon-
