From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible 'destroy' paths for conntracks?
Date: Mon, 07 Mar 2005 14:14:34 +0100
Message-ID: <422C53BA.2020906@trash.net>
References: <422C1FA6.5030701@expertron.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Justin Schoeman <justin@expertron.co.za>
In-Reply-To: <422C1FA6.5030701@expertron.co.za>
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

Justin Schoeman wrote:
> At the moment, I am assuming that there are multiple possible paths for 
> a conntrack to be destroyed, and l7-filter is just missing some.  Is 
> this true?  If so, what are all the possible destructors, or is there 
> one single (better) place to clean up per-conntrack specific memory?

Best place is probably near the call to kmem_cache_free in
ip_conntrack_core.

Regards
Patrick
