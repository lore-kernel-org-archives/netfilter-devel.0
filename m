From: Patrick McHardy <kaber@trash.net>
Subject: Re: aggg Re: libnfnetlink_conntrack encapsulation issues
Date: Sat, 29 Jul 2006 04:11:20 +0200
Message-ID: <44CAC3C8.1070901@trash.net>
References: <44C89B2E.1080401@ufomechanic.net>	<44C89DD8.7030103@ufomechanic.net>	<44C8C6E1.8010004@trash.net>	<44C8CC58.1080909@ufomechanic.net>	<44C8CE76.2090500@trash.net>
	<44C8D11A.6010502@ufomechanic.net> <44C8D4C6.9060100@trash.net>
	<44C8D8B3.5070608@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44C8D8B3.5070608@ufomechanic.net>
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

Amin Azez wrote:
> * Patrick McHardy wrote, On 27/07/06 15:59:
> 
>>Its not a big deal, but I lean towards not taking such a patch as it
>>is a) only used by an external match and b) wrong anyway in my opinion.
> 
> 
> I would lean towards not taking it too, but how else to get
> libnetlink_conntrack to work with arbitrary conntrack attributes?
> And taking the general case of ct_extend? make_atom is my favoured
> solution but it might spoil the _XXX_MSG_MAX idea, or we would need
> multiple atom pools.

I guess the first question we need to answer is if it has too.

>>I actually don't understand the need for the layer7 match at all.
>>The string match with the fsm textsearch algorithm and some clever
>>CONNMARK use should be able to do the same.
> 
> 
> I heard a layer7 guy saying a similar thing about the string match. I
> think. :-) It's not like I'm trying to match a particular layer7
> protocol, I'm trying to match about a hundred, and managing regex's is
> easy. Anyway.... I'm not for making everyone like each-others favourite
> modules; I'm already overusing the mark (IMHO) although some use it
> more, it really is a boon to have the odd extra conntrack attribute
> /that I need/

Last time I looked at the layer7 match (long time ago though), it
didn't do any optimizations for matching multiple patterns, so I think
the string match will perform at least comparable and you will need
log2(n) CONNMARK bits. I really hate this idea that every high-level
function needs an equivalent in the kernel, just because its harder
to use without (with low-level tools).

> I've also extended connmark so that each flow can have its own mark -
> which sort of helps traffic shaping each direction differently.
> Naturally of course, I need to get the extra marks from the conntrack
> database to userspace, along with the original mark. (For compatability
> there are now 3 marks, the traditional mark, and one set for each direction)

I have been using a patch for a long time that extends the conntrack
match by a match on direction, just never made an effort to merge it.
You can encode the direction of each packet in the mark independant
of connmark. I think this approach is a lot more flexible. I'll take
care of adding this (and port matches) sometime if nobody beats me
to it.
