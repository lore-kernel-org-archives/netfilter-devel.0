From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: Counter problem in a new nat target.
Date: Tue, 09 Dec 2003 12:01:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD59D74.6050005@netlab.hut.fi>
References: <Pine.LNX.4.44.0312081319100.10693-100000@filer.marasystems.com>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>On Mon, 8 Dec 2003, Emmanuel Guiton wrote:
>
>  
>
>>Does someone has a good advice on where I can store my variable? Can I 
>>use the void *userdata ? (I do not really know to what it points).
>>    
>>
>
>You should be able to use the userdata I think. It is a pointer to the
>original targetinfo sent/seen by userspace iptables command. The kernel
>operates on another copy of the table per CPU. But I would not recommend 
>doint this. I think it is better if you keep the needed counters 
>elsewhere. You can use reference counting from the check/destroy functions 
>to determine which counters you need to maintain.
>
>Regards
>Henrik
>  
>

Well, things are still unclear for me... I have to admit that I am not 
familiar with reference counting, so I do not really know about this 
possibility.
My problem is that I do not see which data can be accessed by any of the 
function involved. To be precise, I need to increment a counter each 
time I get one new conntrack. Then I decrement it each time a conntrack 
is destroyed or set as assured (tcp connection). The thing is 
complicated by the fact that I have several counters, one for each 
different IP destination address. the selection of the right counter is 
done in the target function.
Thus, I can easily do the increment and decrement when assured in the 
target function. But what about the decrement when a conntrack is destroyed?
Is the destroy function called when a conntrack is destroyed? 
Previously, I was adviced to use a notifier to catch the "conntrack 
destroyed" event. So is this equivalent (without regarding the data 
which can be accessed)?
The hacking howto also states that the checkentry can be used to 
dynalically allocate resources and they can be freed in the destroy 
function. But here the same issue occurs: I do not see which common data 
I can access from bothe the checkentry and destroy function.

Well, I feel I'm just blind and missing an important basic thing, but I 
can't point it out. I hope I won't seem too stupid when the light comes :)

           Emmanuel
