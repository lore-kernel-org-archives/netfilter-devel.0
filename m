From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: size of a rule
Date: Mon, 26 Apr 2004 16:24:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404261609030.6443-100000@filer.marasystems.com>
References: <408D1482.5030009@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <408D1482.5030009@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 26 Apr 2004, Ozgur AKAN wrote:

> Hi,
> I am trying to find the size of a rule in memory.
> 
> const struct ipt_entry *e;
> 
> sizeof (*e) is equal to 112 always. But the size of rule should be 
> different because we can give different parameters to each rule. (I 
> guess that this is the size of the header-like place)

ipt_entry->next_offset gives the size of this rule from what I can 
understand.

> So I looked at the source of libiptc and found this in linux_list.h 
> while searching for the size value.
> 
> #define list_entry(ptr, type, member) \
>         ((type *) ( (char *)(ptr)-(unsigned long)(&((type *)0)->member) ) )
> 
> What is the meaning of ((type *)0)->member ? I can not understand the 
> part with 0.  

The (&((type *)0)->member) is just one way of calculating the offset of
"member" within the datatype "type".

This macro is used by iptables to index various lists.

Regards
Henrik
