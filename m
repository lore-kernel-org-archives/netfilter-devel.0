From: Victor Julien <victor@nk.nl>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Fri, 19 Mar 2004 23:16:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <405B7136.9040807@nk.nl>
References: <Pine.LNX.4.44.0403192301220.13339-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0403192301220.13339-100000@filer.marasystems.com>
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
> On Fri, 19 Mar 2004, Victor Julien wrote:
> 
> 
>>>Then you must use incremental commands, keepint the accounting rule 
>>>untouched.
>>
>>Hmmm, that i don't want.
> 
> 
> Then your other option is to dump the existing rule, parse the counter and
> include this in the input.
> 
> 
>>So i have to read the current counters first by parsing 
>>'iptables-save'-output. And i can then recreate the rules and set the 
>>counters to their old values?
> 
> 
> Yes.
> 
> 
>>Using 'iptables-restore' can i flush one chain, but leave another 
>>untouched?
> 
> 
> Yes, by using disabling the implicit flush (--noflush option) and then 
> use the flush command explicitly.
> 
> 
>>If so, i can create an accounting chain which will not be 
>>flushed...
> 
> 
> True. Probably much better approach than what is discussed above.

So the best option would be to create an accounting chain (e.g ACCOUNT). 
If i, for example, want to recreate the rules in the INPUT chain it 
should work like this:

Create a file for iptables-restore input:

*filter
:INPUT DROP
# flush this chain
-F INPUT
# now recreate the rules
-A INPUT -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
...more rules...
COMMIT

Now i would have to call 'iptables-restore --noflush'. This will clear 
the entire INPUT chain, but will leave all other (including my ACCOUNT 
chain) chains untouched.

Right?

Regards,
Victor
