From: Pablo Neira <pablo@eurodev.net>
Subject: Re: extending conntrack event data
Date: Thu, 21 Apr 2005 13:04:16 +0200
Message-ID: <426788B0.4090908@eurodev.net>
References: <42677180.60003@ufomechanic.net> <42677732.1000905@ufomechanic.net>
	<20050421180723.03CF.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
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
> On Thu, 21 Apr 2005 10:49:38 +0100, Amin Azez <azez@ufomechanic.net> wrote:
> 
> 
>>OK, I see that the skb is only available in ip_conntrack_event_cache and 
>>not ip_conntrack_event. I'm not clear on the different purposes of these 
>>two functions, but I see that both could potentially cause events in 
>>conntrack(-tool). I also see that notifier_call_chain is a general 
>>function and that my suggestion of adding an extra parameter to it is 
>>not likely to be well received.
> 
> 
> ip_conntrack_event_cache() marks a bitmap to indicate that certain event
> occurs. The message will not be delivered immediately due to whatever
> reason such as performance. 

right, performance is the reason why we use event caching. Spamming a 
netlink message to user space every time a packet is received is simply 
"matador" (overkill).

--
Pablo
