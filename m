From: Victor Julien <victor@nk.nl>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Fri, 19 Mar 2004 23:56:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <405B7A8C.6060306@nk.nl>
References: <Pine.LNX.4.44.0403192339160.13628-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0403192339160.13628-100000@filer.marasystems.com>
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
>>So the best option would be to create an accounting chain (e.g ACCOUNT). 
>>If i, for example, want to recreate the rules in the INPUT chain it 
>>should work like this:
>>
>>Create a file for iptables-restore input:
>>
>>*filter
>>:INPUT DROP
> 
> This line is redundant. You only need policy lines if you want to change 
> the policy.

But i do need it if i want to (re)set chain counters, right?

Like this:
:INPUT DROP [123:45678]

> 
>># flush this chain
>>-F INPUT
>># now recreate the rules
>>-A INPUT -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
>>...more rules...
>>COMMIT
>>
>>Now i would have to call 'iptables-restore --noflush'. This will clear 
>>the entire INPUT chain, but will leave all other (including my ACCOUNT 
>>chain) chains untouched.
> 
> Correct.
> 
> But dont forget to insert a jump to the ACCOUNT chain where needed..
> 
> *filter
> -F INPUT
> -A INPUT -j ACCOUNT
> -A INTPUT -p tcp .... -j ACCEPT
> ....
> COMMIT
> 
Well, i think i know all i need now, thanks a lot for your help! Now i 
stand for the daunting task of implmenting this in my current codebase ;-)

Well i guess that will have to wait a bit, my current version is quite 
stable (for me a least) and i plan to release it soon...

Regards,
Victor
