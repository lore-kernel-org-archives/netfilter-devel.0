From: Michal Soltys <soltys@ziu.info>
Subject: Re: [PATCH] xt_u32.c - make negative offsets work near / at the end
 of packet
Date: Sun, 06 Sep 2009 11:31:11 +0200
Message-ID: <4AA3815F.1020601@ziu.info>
References: <1252197398-23863-1-git-send-email-soltys@ziu.info> <alpine.LSU.2.00.0909060253510.4335@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from drutsystem.com ([80.72.38.138]:1971 "EHLO drutsystem.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbZIFJbL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Sep 2009 05:31:11 -0400
In-Reply-To: <alpine.LSU.2.00.0909060253510.4335@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2009-09-06 02:36, Michal Soltys wrote:
>>But with current xt_u32.c code this is impossible due to subsequent
>>sanity checks:
>>
>>        if (at + val < at)
>>                return false;
>>        at += val;
>>        pos = number;
>>        if (at + 4 < at || skb->len < at + 4 (#3) ||
>>            pos > skb->len - at - 4 (#4) )
>>                return false;
>>
>>        if (skb_copy_bits(skb, at + pos, &n,
>>            sizeof(n)) < 0)
>>
>>In particular, condition (#3) will make the function return false, if
>>'at' is at / near the end of packet, regardless of the 'pos' value used.
>>Furthermore, (#4) would inhibit any "negative" 'pos' value anyway.
>>
>>If I haven't missed anything,
> 
> The code stems from Patrick's comments [to my original u32 submission]
> about overflow checks. It seems you are basically throwing these
> out of the window.
> 
>>        at += val;
> 
> This can overflow. Or if @val is signed, it may even underflow, and
> surely give funny results when @at is unsigned at the same time.
> Then there is also the question on what should happen when you
> deal with values that are - in their respective context as
> defined in an RFC or something - uint32_ts. Though probably a little
> unlikely in the real world at this time, I would not count on
> never hitting a jumbo frame size field of, say, 2147483656 bytes.
> 
>>        if (at + number + 4 < 4 || skb->len < at + number + 4)
> 
> at+number can overflow, so can at+number+4.
> The check is insufficient too, because let at+number+4 may yield,
> through overflows, a value that is still greater than 4.
> 

The first check is against "left side" and it should be greater 
than 4 for the function to not return false immediately. If it's too great 
it will be caught by the second test.


More detailed rationale:

I know this and previous (as you commented) can overflow, but we're 
checking the final result here. Regardless of the value of at, val and pos 
during computations (or how we interpret them) - the final check is done 
using unsigned values and tested against "where would skb_copy_bits end".

The first check makes sure the read starts at least from 0 (that's why 
at + number + 4 must be bigger or equal 4 for it to pass). And it's 
written this way so it works properly with all the variables being 
unsigned (of course I couldn't do: at + number < 0 as that would never be 
true with unsigned vars).

The second check makes sure skb_copy_bits doesn't try to read past skb. 
For example:

at  = 0x11       (17)
val = 0xfffffffb (user interp. as -5)
pos = 0xfffffff6 (user interp. as -10)
skb->len = 21

at + val + pos + 4 = 2

The tests here: 6 < 4 and 21 < 6 - so all is fine (all tests are false)

But with val -8 and pos -10 we would get: 3 < 4 and 21 < 3 (return on first).
    with val -20 and pos -20 we would get: 0xffffffed < 4 and 21 < 0xffffffed (return on second).

and so on...

All values in xt_ut32.c are defined as strictly unsigned and 32 bits wide. All values 
supplied on the command line or read from packet's data will be treated as such, but 
can be interpreted any way - add and sub instructions don't really care for that, operation 
and data is the same (that's where my qeustion about non-x86 archs came from).

17 + 0xffffffff (-1) is 16
0xfffffff0 + 0xffffffff (-1) is 0xffffffef

... well, you see my point. Iptables will take signed values w/o any problems, but will 
output them (-L) as unsigned.

I've been running u32 patched this way, and tested with clearly wrong rules such as:

'0 << 25 @ -30000 & 0xFF = 0:0xFF'
'0 & 0 @ -30000 & 0xFF = 0:0xFF'
'0 & 0 @ 30000 & 0xFF = 0:0xFF'

and as expected, never ran into any problems.
