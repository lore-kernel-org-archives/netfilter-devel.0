From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter supporto for entry data
Date: Fri, 26 May 2006 15:42:17 +0200
Message-ID: <447705B9.4080809@trash.net>
References: <200605260019.16027.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200605260019.16027.max@nucleus.it>
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
> Hi,
> I wrote some time ago about the possibility of entry specific data for 
> matches. There are several matches that could use a pointer to a structure 
> allocated and initialized during checkentry() and disposed of during 
> destroy().

Yes, sorry for not responding earlier.

> 
> Is there any reason the API doosn't provide a way to do this?
> 
> I'd like to change these structures (and all corresponding references and 
> initialization code) as follows:
> 
> struct xt_match
> {
> ...
>         int (*match)(const struct sk_buff *skb,
>                      const struct net_device *in,
>                      const struct net_device *out,
>                      const void *matchinfo,
>                      int offset,
>                      unsigned int protoff,
>                      int *hotdrop,
>                      void *instance_data);
> 
>         int (*checkentry)(const char *tablename,
>                           const void *ip,
>                           void *matchinfo,
>                           unsigned int matchinfosize,
>                           unsigned int hook_mask,
>                           void **instance_data);
> 
>         void (*destroy)(void *matchinfo,
>                         unsigned int matchinfosize,
>                         void *instance_data);
> ...
> };
> 
> 
> struct xt_entry_match
> {
> ...
>         void *instance_data;
>         unsigned char data[0];
> };
> 
> 
> This would solve the general problem of entry specific data (tracking, state, 
> accounting, whatever).
> It gives more expressiveness to the API in general and would have little 
> impact on the parts of the code that do not use it (instance_data is 
> initialized as NULL and never used).
> The performance penalty would be negligible (4 or 8 more bytes in every 
> descriptor and in every function call to the match function).
> 
> We could minimize impact on the existing code introducing a "normal" and an 
> "extended" match funciton prototype, but this would crete complexity and its 
> only purpose is if we don't want to upgrade everything.


Your goals are definitely worthwhile, but if we find a working solution
we should just convert everything.

> The problem with my solution is:
> - it's work (I could do it, so it's not your problem :));
> - the kernel people may reject it or delay it for an extended period of time;
> - while the patch is available and the kernel people does not accept it 
> we'll be stuck with 2 sets of incompatible netfilter APIs with all kinds of 
> inconveniences while everyone updates their function declarations (we already 
> survived one such change with 2.6.16).


We try not to unreasonably reject good patches :) In this case however
the patch breaks userspace compatibility (xt_entry_match is also used
by userspace), so this isn't possible.

Mhh .. thinking about it some more, we might be able to squeeze it
into the u.kernel part, there should be enough room left in there.
