From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Tue, 17 Aug 2004 02:44:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <412154E9.7040905@trash.net>
References: <E1BwO5M-000718-NF@giant.mindlink.net>	 <1092692707.22731.1687.camel@marx.mindlink.net>	 <41213777.9050701@trash.net> <1092703243.22731.1778.camel@marx.mindlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matt Walters <mattw@parasun.com>
In-Reply-To: <1092703243.22731.1778.camel@marx.mindlink.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Matt Walters wrote:

>On Mon, 2004-08-16 at 15:38, Patrick McHardy wrote:
>  
>
>>skb_tailroom should return 0 in this case and the skb should be linearized
>>by skb_copy_expand already. The check isn't triggered because this line is
>>wrong:
>>
>>diff = v->data_len - e->skb->len
>>
>>skb->len is the total length, including fragments. If we want to copy to it,
>>we either need to linearize it or look at skb_headlen(skb). It's complicated
>>getting everything right, I need to think about it some more.
>>    
>>
>
>	Yeah, and for some twisted reason I was figuring on skb_copy_bits to do
>that (since it *does* unwind fragment lists, etc).  My apologies for the
>waste of bandwidth.
>  
>
No problem, your testing provided valuable information about the cause 
of the
problem.

Regards
Patrick
