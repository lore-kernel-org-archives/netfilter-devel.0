From: Justin Schoeman <justin@expertron.co.za>
Subject: Possible 'destroy' paths for conntracks?
Date: Mon, 07 Mar 2005 11:32:22 +0200
Message-ID: <422C1FA6.5030701@expertron.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

[I am not on the list, so please CC me any answers.]

Hi all,

I am trying to locate a memory leak, either induced by, or agravated by 
the l7-filter.

Using the slab debugger, I see that the memory that is leaking are the 
app_data and/or app_proto fields that are kmalloc'ed in the 'match' method.

These are then (supposed to be) kfree'ed in the destroy_conntrack 
function, but they are apparently not destroyed, as even after most 
active connections have closed/timed out (/proc/net/ip_conntrack is 
practically empty), there are still thousands of these kmalloced memory 
regions left.

At the moment, I am assuming that there are multiple possible paths for 
a conntrack to be destroyed, and l7-filter is just missing some.  Is 
this true?  If so, what are all the possible destructors, or is there 
one single (better) place to clean up per-conntrack specific memory?

Thanks,
Justin
