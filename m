From: Leon Bene <leon@benesconsulting.com>
Subject: Looking for IPtables developers - Need help at core of
  iptables (not configuration)
Date: Tue, 27 Jul 2004 11:59:38 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.0.9.2.20040727115216.00aa0a30@pop.benesconsulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
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

I am using iptables in Redhats' release (ES) of Linux. In version 7.1 of 
Redhat (iptables 1.2.1a) it forwarded packets just fine. Now with iptables 
1.2.8 the outbound traffic hangs for about 5 seconds on rapid small packet 
transmissions.

I am not asking for support just a question about iptables 1.2.8. It looks 
like iptables 1.2.1a just passed on packets and did not keep track of the 
number of unanswered packets, with 1.2.8 it behaves like it keeps track of 
unanswered packets and stops (waits) once the buckets are filled until some 
packets clear. Is this true? I am trying to understand the differences in 
1.2.1a and 1.2.8 that would lead to the hanging.

Thanks, and if I need to pay or donate then tell me where and I am happy to 
do so.

Leon Bene'
