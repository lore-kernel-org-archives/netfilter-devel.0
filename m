From: KOVACS Krisztian <hidden@balabit.hu>
Subject: POM conditional parts
Date: Fri, 28 Nov 2003 13:28:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FC73F50.3050700@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

   I'd have a question regarding POM and dependencies. I'm currently 
working on NAT tuple reservations, and have a problem: I'd like to change 
the number of arguments of ip_nat_used_tuple(). However, it's also used 
outside of the NAT core: the unique_tuple() functions of the per-protocol 
NAT modules use it.

   So, if I'd like to prepare a POM patch which changes 
ip_nat_used_tuple(), it breaks other patches (for example GRE NAT). So, 
I'd need some "conditional patches" functionality, e.g. parts of the NAT 
reservation patch should be applied only if some other patch is applied... 
AFAIK, this is not possible with current POM. Any ideas?

-- 
   Regards,
     Krisztian KOVACS
