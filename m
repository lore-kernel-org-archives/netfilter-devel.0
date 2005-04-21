From: Amin Azez <azez@ufomechanic.net>
Subject: Re: extending conntrack event data
Date: Thu, 21 Apr 2005 12:04:20 +0100
Message-ID: <426788B4.2060400@ufomechanic.net>
References: <42677180.60003@ufomechanic.net> <42677732.1000905@ufomechanic.net>
	<20050421180723.03CF.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050421180723.03CF.LARK@linux.net.cn>
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

Wang Jian wrote:

>Hi Amin Azez,
>
>On Thu, 21 Apr 2005 10:49:38 +0100, Amin Azez <azez@ufomechanic.net> wrote:
>  
>
>>It is thus not practical to do as I suggested and make skb information 
>>available at conntrack events.
>>
>If we use skb everywhere (because it can contains conntrack information),
>then you can do what you want.
>  
>
That would be fine, but it looks like the skb is lost a few layers up 
the function calls except for the  *event_cache() calls, so this may 
involve a lot of changes? I guess the question is "which do we prefer?".

Adding to the conntrack is cleanest, it touches only conntrack_core and 
conntrack_standalone and is protected by a kernel CONFIG_ define.
Passing the skb instead of the conntrack is more flexible but will touch 
a lot more code. I would think Pablo or Harald are better placed to make 
that call.

I'm working on adding the option of link-layer to the conntrack struct 
as it is cleanest, perhaps genuinely more useful, and will have the most 
compact patch if I have to maintain it outside the core kernel.

Sam
