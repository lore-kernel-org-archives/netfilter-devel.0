From: Nick Hay <nickjhay@hotmail.com>
Subject: Extending LOG target to display pid
Date: Wed, 06 Jul 2005 04:05:54 +1200
Message-ID: <42CAAFE2.3050606@hotmail.com>
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

What I hoped to be an easy hack quickly ran into problems.  I planned to 
add an extra printk() in dump_packet() to output the pid, and perhaps 
the program executable number.  Since the owner module had access to the 
pid, I assumed there would be some way to get this information to the 
LOG module.  After a frustrating search through source code and 
documentation, I have the following questions:

1. For the owner module, where/how is the struct ipt_owner_info filled 
in for each packet?  In general, how is the ipt_entry_match/target data 
field filled in?

2. Any ideas on how I can get the pid of a local packet's creator in the 
log module?  I couldn't find any structures connected to the sk_buff 
that might contain it, and couldn't think of where the data would 
originally come from.

Actually... would current->pid work?

I'm still curious about question 1, though!

-- Nick Hay
