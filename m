From: dmorris <dmorris@metavize.com>
Subject: Re: [PATCH] ipt_do_table accesss pskb after it has been freed
Date: Fri, 07 Nov 2003 08:09:35 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FABC3BF.7070808@metavize.com>
References: <3FAB00E7.1030507@metavize.com> <20031107085752.GH5741@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031107085752.GH5741@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>>I had a target in the mangle/PREROUTING that was freeing the skb and 
>>returning NF_STOLEN.
>>ipt_do_table would then cause a kernel panic as it accesses the skb 
>>after its freed.
>>
>>Is this a bug? If so, here's the patch.
>>    
>>
>
>no, it's not a bug.  you should return NF_DROP if you want to have the
>skb dropped.
>
What am I supposed to do if there is no skb to be dropped.
My hook calls some other functions in the kernel which call
skb_free if all is not well.
That leaves me with two choices, either make a copy of the skb,
which i cant do for performance reasons, or apply this patch.

Do I have other options?
Does the netfilter code assume that skb_free cannot be called from 
within hooks?
and do you see any unintended consequences of this hack?

-dirk
