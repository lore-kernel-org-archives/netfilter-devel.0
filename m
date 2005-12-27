From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: How to obtain process ID that created connection or owns one
 packet
Date: Tue, 27 Dec 2005 20:28:06 +0100
Message-ID: <43B195C6.8020704@eurodev.net>
References: <1b8130000512182054y7208121dtb6b20814540bbb3b@mail.gmail.com>	<43A6EA58.9090201@eurodev.net>	<43A6EC1F.7030600@eurodev.net>	<43ABED47.8070100@gmail.com>	<43AC263E.7080508@gmail.com>
	<43AD5934.3050700@eurodev.net> <43B180CA.7060808@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <43B180CA.7060808@ingate.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Marcus Sundberg wrote:
> Pablo Neira Ayuso wrote:
> 
>> Mikado wrote:
>>
>>> Thanks all! Finally I found the answer in 'struct sk_buff':
>>>
>>> struct sk_buff ( #include <linux/skbuff.h> )
>>> |_struct sock ( #include <net/sock.h> )
>>>  |_struct socket ( #include <linux/net.h> )
>>>    |_struct file ( #include <linux/fs.h> )
>>>      |_struct fown_struct ( #include <linux/fs.h> )
>>>        |_int pid
>>
>>
>>
>> Yes, but AFAIK you can only use that in the OUTPUT hook, not in the
>> INPUT path.
> 
> ...and if using SMP you can't use it at all in netfilter context.

And there's still some work in progress about this:

http://lwn.net/Articles/157137/

-- 
Pablo
