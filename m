From: Swapnil Nagle <swapsn@rediffmail.com>
Subject: positive target->verdict
Date: Tue, 10 Aug 2004 21:26:59 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4118F04B.5090505@rediffmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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


Hi all,

Short query :

What is the significance of a positive verdict in ipt_standard_target ?
 Its supposed to be a jump offset, but is it from :
 - beginning of current chain
 - relative to a current ipt_entry

The netfilter-hacking howto only mentions that its an offset.

Long version :

I was looking at the struct ipt_replace generated for this rule :

iptables -A INPUT -d 192.168.1.1 -j REJECT

The first ipt_entry for INPUT chain (i.e repl->hook_entry[1]) has a 
verdict 3.

Does that mean that its a jump and the next ipt_entry is the 3rd one 
from the beginning of this chain ?

Regards,
Swapnil.
