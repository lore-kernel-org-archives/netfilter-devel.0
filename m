From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6 0/12]: netfilter update
Date: Wed, 22 Sep 2004 03:42:24 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4150D880.70108@trash.net>
References: <414F9DFC.701@trash.net> <20040921143611.6a6e2f60.davem@redhat.com>
	<4150BB62.2060904@trash.net>
	<20040921171857.2c720c8e.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20040921171857.2c720c8e.davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

David S. Miller wrote:

>Thanks, two problems:
>
>1) Please layout the new skbuff.h structure changes more
>   intelligently.  Currently the netfilter stuff is:
>
>	pointer
>	u32
>	pointer
>	u32
>
>   and this wastes a lot of space on 64-bitters.
>
Oops. That wasn't very smart of me.

>2) There is no way I'm amicable to exporting __tcp_v4_lookup()
>   and friends to modules.
>
>   Are you absolutely sure that the existing scheme cannot
>   work properly?  I'm talking about relying upon skb->sk
>   being sane.
>  
>
The existing scheme has one problem, it takes files->file_lock
in a BH, but the patch doesn't mean to fix this. Besides
this, it works fine. The patch extends the owner match so it
can also be used in the input path, where skb->sk isn't set.
This is quite useful for filtering input traffic based on user
etc., unfortunately it can't be done without exporting
{tcp,udp}_v4_lookup. Do you see an alternative to dropping the
patch ?

>So what I think I'll do is merge in all the changes other
>than the ipt_owner.c change by hand into a tree I'll push
>to Linus, I'll also fix the layout ordering problem which
>I mentioned above in #1
>  
>
Thanks.

Regards
Patrick
