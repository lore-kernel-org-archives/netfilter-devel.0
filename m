From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC][DRAFT][PATCH] iptables 32bit compat layer
Date: Wed, 18 Jan 2006 01:38:41 -0800 (PST)
Message-ID: <20060118.013841.123630757.davem@davemloft.net>
References: <43CE0696.50407@openvz.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: dim@openvz.org, akpm@osdl.org, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dev@openvz.org
In-Reply-To: <43CE0696.50407@openvz.org>
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

From: Kirill Korotaev <dev@openvz.org>
Date: Wed, 18 Jan 2006 12:12:54 +0300

> This patch extends current iptables compatibility layer in order to get
> 32bit iptables to work on 64bit kernel. Current layer is insufficient 
> due to alignment checks both in kernel and user space tools. Current 
> draft version works correctly with standard targets only 
> (ACCEPT/DROP/FORWARD).
> 
> ToDo:
>   - extend translation to include more matches and targets. Use arrays of
>     structures like { name, size_diff, func_for_convert_data} for this
>     purpose
>   - extend get_info to return corrected size. Add size calculation to
>     get_entries.

Thanks for doing this work.

But it would make a lot more sense to add
compat_setsockopt and compat_getsockopt socket
operations, call down into there, and then implement
these translations inside of netfilter itself.

This would avoid an enormous amount of copying
and munging, and also would keep netfilter internals
outside of the generic socket compat layer code.

Thanks.
