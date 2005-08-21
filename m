From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 10:36:15 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0508210950130.2412@yvahk01.tjqt.qr>
References: <20050820172824.GE5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508202154050.18226@yvahk01.tjqt.qr>
	<20050820202552.GF5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508210021050.22186@yvahk01.tjqt.qr>
	<20050821043728.GH5638@aaricia.csbnet.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20050821043728.GH5638@aaricia.csbnet.se>
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



On Aug 21 2005 06:37, Joakim Axelsson wrote:
>>>Its a _very_ large router infront of a student network. It house sover 2000
>>>computers behind it and has a traffic amount between 50Mbit and 400Mbit
>>>[...]

>Please do not debate my networks firewall setup. It is complex. OK. Please
>just try to solve my little problem by eleminating the number for chains
>needed. 

Maybe we misunderstood because I was not clear - the rules being _traversed_ 
should best be low; that the total number of rules may drop then is a side 
effect, but always welcome.

>url

This looks ok - "big networks" always sound like

  -d 1.2.3.4(/32) -p tcp --do somethign here
  -d 1.2.3.4(/32) -p udp
  -d 1.2.3.5(/32) -p ...
  -d 1.2.3.6(/32) -p ...

(which is really inefficient for a single ip if done for all possible ipaddrs, 
in which case I would probably propose a 4-level digital tree approach.)

>And also, a jump might be very costly if the jump is so far away in memory
>that a cache miss is triggered. This is not unlikly at all as i have so many

This is not a jump at the assembler level, or to put it another way, a -j call 
is not just push-and-pop. If you look at the goto linux.patch, you'll find 
that it adds

   if (table_base + v
        != (void *)e + e->next_offset && !(e->ip.flags & IPT_F_GOTO)) 

the !(e->ip.flags & IPT_F_GOTO) part only, so in case of -g, the whole if() 
body is not run at all.

>However, my original question is stuck. I want to make a -m log which can
>printk me the current chain i'm in. Or if that helps you, i want a -m
>chain_debug that prints the chain, for any purpose.

I have looked into the code, and it seems to me that in the end, there are 
only "tables" with "rules" (indexed by number), so...

  -t filter -A INPUT -j mychain
  -t filter -A mychain -j LOG

will probably end up as

  filter[0] = jump to [2]
  filter[1] = return
  filter[2] = log
  filter[3] = return

so the record of the chain name is dropped early - probably at the 
user<->kernelspace gate. I am deriving this assumption from

  e = get_entry(table_base, v)

where v is an integer.

>ipt -A chain -p tcp --syn 
>             -m return --return-if-next-match-fail \
>             -m limit --lim-packets ! 1000/s \
>             -m log --log-prefix "DROPing overlimits" \
>             -j DROP
>ipt -A chain -p tcp ...
>ipt -A chain -p udp ...
>...
>
>Now i have ONE rule per matching class and limiter. Just what i wanted. Some
>ugly hack perhaps, but i do this so often in my firewall (not just in -i
>raw) that it might be just okej.

An interesting thing indeed.
Oh btw the proper syntax for inverts should be ! --lim-packes 1000/s


>/Joakim Axelsson A.K.A Gozem@EFnet


Jan Engelhardt
-- 
| Alphagate Systems, http://alphagate.hopto.org/
