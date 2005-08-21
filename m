From: Munteanu Eduard Gabriel <maxdamage@aladin.ro>
Subject: Multiple targets for REDIRECT & friends
Date: Sun, 21 Aug 2005 13:40:22 +0000
Message-ID: <43088446.6000303@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

I'm looking to contribute this to netfilter.

Right now, ip_nat_multi_range is typedeffed (as a macro, though) to 
ip_nat_multi_range_compat. I think it will be okay to make 
ip_nat_multi_range be a linked list, but eliminate rangesize member. 
Older targets will preserve ip_nat_multi_range_compat, while those which 
support multiple targets will use this new structure.

However, there is a problem and I need your help. Linked lists need 
linux/list.h, but that one checks for __KERNEL__ and backfires when you 
need to compile iptables. As I see it, there are two solutions for that:
1) Using a "ip_nat_multi_range *next" pointer instead of using kernel's 
list_head. This fulfills all requirements for my patch, but I don't know 
if it's okay for kernel devels to use nonstandard lists (though there is 
no single-linked list implementation in kernel AFAIK).
2) Providing different linux/list.h in iptables package. This will bring 
up future API compatibility issues, so we need to maintain that header 
and insert checks for kernel version.
3) Modify linux/list.h so that it doesn't check anymore for __KERNEL__. 
Kernel devels won't be happy about this AFAICS.

If you have any other advice regarding my ideas on how to implement 
this, feel free to ask. I already came up with a patch for iptables' 
REDIRECT target, it just needs to have that linked list thingy filled up.
