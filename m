From: Patrick McHardy <kaber@trash.net>
Subject: Re: [00/10]: Netfilter Update
Date: Thu, 23 Mar 2006 04:48:28 +0100
Message-ID: <44221A8C.7000601@trash.net>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
	<20060322.135906.60572272.davem@davemloft.net>
	<44221A45.7060003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <44221A45.7060003@trash.net>
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

Patrick McHardy wrote:
> David S. Miller wrote:
> 
>>>     [NETFILTER]: Fix undefined references to get_h225_addr
>>
>>
>>I never in a million years would have thought that exporting
>>a symbol to modules would work if the symbol was declared
>>static :-)  But come to think of it, I see nothing that prevents
>>this.
>>
>>I wonder if this could be prevented somehow using so me construct
>>in the module symbol export macros?
> 
> 
> I was surprised too. Looking at the gcc-builtins, there seems to
> be no way to determine if a function is static. But this small
> hack appears to work. It adds a non-static forward declaration of
> the exported function to the function body, causing a warning
> if the function was declared static.

Outside the function body of course.

> 
> 
> ------------------------------------------------------------------------
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 70bd843..f8eec37 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -183,6 +183,7 @@ void *__symbol_get_gpl(const char *symbo
>  
>  /* For every exported symbol, place a struct in the __ksymtab section */
>  #define __EXPORT_SYMBOL(sym, sec)				\
> +	typeof(sym) sym;					\
>  	__CRC_SYMBOL(sym, sec)					\
>  	static const char __kstrtab_##sym[]			\
>  	__attribute__((section("__ksymtab_strings")))		\
