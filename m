From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_get doesn't call nf_conntrack_get(&ct->ct_general)
Date: Fri, 02 Sep 2005 00:05:15 +0200
Message-ID: <43177B1B.4010207@trash.net>
References: <006101c5af27$2087e750$dd8069d8@html>
	<Pine.LNX.4.62.0509011526550.14997@dgray-test.acs.internap.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Damon Gray <dgray@internap.com>
In-Reply-To: <Pine.LNX.4.62.0509011526550.14997@dgray-test.acs.internap.com>
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

Damon Gray wrote:
> 
> Until I looked more closely I always assumed ip_conntrack_get was doing
> the proper reference counting, and I would always call ip_conntrack_put
> for everything I was "getting". The problem is that ip_conntrack_put calls
> nf_conntrack_put(&ct->ct_general) but ip_conntrack_get *does not* call
> nf_conntrack_get(&ct->ct_general). Problem? If so I would be happy to
> send a patch.

This is one of the uglies of ip_conntrack. ip_conntrack_get just returns
the nfct pointer from the skb and the nfctinfo field in *ctinfo, without
increasing the refcnt, refcounting is done using nf_conntrack_get.
Before nfctinfo was introduced, ctinfo it had to be derived from the
nfct pointer, which is why ip_conntrack_get exists. Cleanup patches in
this area would be very welcome, but it should be done for nf_conntrack,
which copied this part of ip_conntrack.
