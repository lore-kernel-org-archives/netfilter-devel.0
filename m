From: Pablo Neira <pablo@eurodev.net>
Subject: Re: libipq: man page != online doc and a question
Date: Sat, 16 Oct 2004 18:52:40 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417151D8.3080506@eurodev.net>
References: <20041015192145.383e8bd9.tigrezno@log01.org>	<41714C50.8060400@eurodev.net>
	<20041016175921.71c207d0.tigrezno@log01.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jvalencia <tigrezno@log01.org>
In-Reply-To: <20041016175921.71c207d0.tigrezno@log01.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jvalencia wrote:

>>>This man page dates from 2001 :S
>>>
>>>Online netfilter hacking guide tells about NF_ACCEPT, NF_DROP, NF_QUEUE and NF_REPEAT.
>>> 
>>>
>>>      
>>>
>>yes, these are all possibles verdicts in a *kernel hook*, not in ip_queue
>>    
>>
>
>mmm but I was able to use NF_QUEUE in ipq_set_verdict using libipq.
>
>ipq_set_verdict(h, m->packet_id, NF_QUEUE, 0, NULL);
>Exit code was 28, a success.
>  
>

you are right, actually I was having a look at that right now :), but 
does it make any sense issuing NF_QUEUE as verdict from an ip_queue user 
space program?

You are right again, you can also issue a NF_REPEAT. Maybe you could 
update that manpage, have a look at the CVS and post a patch to the 
maillist.

>>>Can I send the packet to another chain with verdicts?
>>> 
>>>
>>>      
>>>
>>what do you mean?
>>
>>    
>>
>
>In iptables you have various chains, as INPUT, OUTPUT and other user created as "icmp_traffic" for example. 
>I want to move a packet to a chain as "strange_traffic" from libipq because of its content. Is this possible?
>  
>

no, AFAIK iptables and ip_queue doesn't have a way to interchange 
information between them. If you like, give me more information about 
you want to do, I'll see if I can help you out.

regards,
Pablo
