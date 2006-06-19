From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] entry_data
Date: Tue, 20 Jun 2006 01:37:13 +0200
Message-ID: <44973529.50600@netfilter.org>
References: <200606050029.08602.max@nucleus.it>
	<200606132256.10384.max@nucleus.it>
	<4495EC8E.6030006@netfilter.org>
	<200606190902.09597.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606190902.09597.max@nucleus.it>
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

Massimiliano Hofer wrote:
> 
>>                         /* Used inside the kernel */
>>                         struct xt_match *match;
>>+                       void *entry_data;
>>                 } kernel;
>>
>>You can't modify the layout of xt_entry_[match|target] since this
>>structure is shared between userspace (iptables) and kernel space.
> 
> 
> You're right, but I modified the kernel side of a union and I was careful not 
> to change the total size. This union is never really used by both sides 
> simultaneously.

Indeed, you're right, I can't see any problem with your patch at this 
moment. Although apart from the out of tree xt_condition match, there is 
no other clients for entry_data. I'd like to know what Patrick thinks 
about this.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
