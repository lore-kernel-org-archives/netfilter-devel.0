From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: My first target module is a fiasco.
Date: Mon, 15 Dec 2003 17:48:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FDDD7E6.703@netlab.hut.fi>
References: <3FDDD174.5050409@netlab.hut.fi> <3FDDD4FD.6080204@balabit.hu>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

KOVACS Krisztian wrote:

>
>   Could you show us the code of the init function, and the static 
> structure it registers? However, it looks like the kernel thinks your 
> module failed to load (its __init function did not return 0), however, 
> it has successfully registered its target... This is bad, since the 
> memory allocated for your module is freed when your __init function 
> returns any value other than zero.

Zero... Do you mean that "return 0;" at the end of my __init function is 
more appropriate than the current "return 1;"? :)
Well, I must admit that it works better like that... :) Thanks.

           Emmanuel
