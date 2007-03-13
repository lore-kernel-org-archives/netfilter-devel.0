From: Amin Azez <azez@ufomechanic.net>
Subject: Re: dangerous? Setting mark in nat table
Date: Tue, 13 Mar 2007 16:12:44 +0000
Message-ID: <45F6CD7C.40708@ufomechanic.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
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

* Jan Engelhardt wrote, On 13/03/07 15:36:
> On Mar 13 2007 15:25, Amin Azez wrote:
>> I want need to set a mark (-j MARK) in the nat table based on dnat'ing done.
>>
>> This means changing the ipt_mark kernel module, at least for my own
>> consumption.
>>
>> Are there any overpowering reasons why I should not do this, or even why
>> it should not be done at all?
> 
> It is valid from a programming point of view (the @skb is always writable
> a.k.a. it is not in a rodata section protected by hardware, which is why
> it can also be modified from within matches which have const struct
> sk_buff *skb), but it is perhaps some sort of layering violation (MARK is
> for mangle only). I recognize that it would be cheapest to MARK packets
> _after_ the whole lot of bad packets has been dropped in filter, rather
> than having to mark them first in mangle and then just filter it out
> again.


Heh, I spoke to soon.
1. x_tables.c already supports a null table name meaning no-restriction
(although this may be historic rather than planned) so I could just
remove the table name from xt_MARK
2. CONNMARK (as I used it) doesn't set a table restriction anyway,
so..... I'll just use CONNMARK for now.

Sam
