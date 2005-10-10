From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Netfilter ContextID
Date: Mon, 10 Oct 2005 14:04:18 +0100
Message-ID: <434A66D2.3040304@ufomechanic.net>
References: <4342C967.2050308@airmail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4342C967.2050308@airmail.net>
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

What is the purpose of this contextid?

If iptables itself is not going to make use of it, why not re-calculate
it on demand when you read rules back using iptables -L?

Or if you need to be able to store abritrary cookie values, there is a
comment module for iptables which allows you to store up to 255 bytes of
text.

How to do this really depends on the purpose of this context and what
else is supposed to respond to it.

Sam

Jerry Alexander wrote:
> Dear Netfilter-devel:
> 
>     Working on implementing packetswitching.
>     Of course  Iptables/Netfilter looks like the
> correct medium to do so.
>     Loaded things up and  iptables could
> Add(append), subtract(delete) and move(replace) UDP/IP
> connections.
>     Wrote a base module using nf_register_hook at PREROUTING
> to gather packet stats.
>     My problem is this.  My manager wants a "ContextId"
> generated during the a  add,subtract,move commands.  Of
> course this would have to be unique(using a hashing algorithm
> which uses the IP address and the Port Number).
>     Right now this looks like it would need to be generated in the
> kernel module.   But this would require all the Append/delete/Replace
> command functions moved to the kernel function also!!
>     Hoping someone can point me in the right direction on how
> this would be done using Iptables and Netfilter.
> 
>                                  Thanks,
>                                         Jerry
> 
> 
> 
