From: Simon Lodal <simonl@parknet.dk>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 07:42:38 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415A4B4E.1080801@parknet.dk>
References: <415A12AE.1060901@parknet.dk> <415A3263.7080708@xgendev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ben Efros <ben@xgendev.com>
In-Reply-To: <415A3263.7080708@xgendev.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


What tools are passing IP's literally as full 32bits? I understand why 
programs (especially in script languages) might do it internally, but 
between programs?

Funny, works with ping, but not ssh. Works with iptables for --src and 
--dst (surprise). But not for SNAT --to-source.

Just looked at RFC 1123, it only talks about dotted decimal 
representation. The 32bit form is not even documented anywhere afaik, 
and honestly I do not remember seeing it.

If it is really a problem I agree my scheme will break it. Could 
probably be solved by changing the default to incomplete-at-beginning, 
so 10 = .10 = 0.0.0.10.


Simon


>> Iknow IP address syntax should not change every day. But this will not 
>> break or exclude old syntax. I do not see it clashing with 
>> other/future syntax.
> 
> 
> Wrong.  IP numbers can also be written in 32-bit unsigned notation.  In 
> your first example:
> 10 being  10.0.0.0/8
> 10 is actually treated as unsigned 32bit int, meaning you're address is 
> actually 0.0.0.10
> Try this command and see for yourself:
> "ping 5000"
> Notice how ping is actually sending to "0.0.19.136" ?
> 
> This is done because 32-bit addresses should be representable as a 32bit 
> number and not just as a string representation of the address for a 
> variety of reasons.
> 
> Unfortunately your idea would break a LOT of very useful tools and ways 
> of representing valid ip numbers.
> 
> Ben
