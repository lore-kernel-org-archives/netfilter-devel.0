From: Jon Webb <jon_webb@binary-one.com>
Subject: multicast group traffic filtering
Date: Mon, 22 Dec 2003 01:54:04 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FE6BF3C.9030400@binary-one.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi everyone,
I am trying to think of a way to handle a multicast test network. We 
have a setup that may require having a multicast router in a network 
that contains other multicast activity. This extra router would only 
want to route multicast traffic (control and data) for a specific 
multicast group (our test group), ignoring all other multicast traffic 
not part of that group. I know that the matching code is able to match 
on a multicast packet type, but I need to match on a specific group. I 
looked around the docs, but have been unable to find any kind of --match 
type support for multicast group ID's or some sort of IGMP connection 
tracking/handling. Is there something I missed? Can this be done with 
existing tools? Or else, could this be easily constructed?

Thanks,
Jon

-------------
jon_webb@binary-one.com
jonwebb@soe.ucsc.edu
Computer Communications Research Group
University of California, Santa Cruz
