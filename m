From: Patrick McHardy <kaber@trash.net>
Subject: Re: aggg Re: libnfnetlink_conntrack encapsulation issues
Date: Thu, 27 Jul 2006 16:59:18 +0200
Message-ID: <44C8D4C6.9060100@trash.net>
References: <44C89B2E.1080401@ufomechanic.net>	<44C89DD8.7030103@ufomechanic.net>
	<44C8C6E1.8010004@trash.net>	<44C8CC58.1080909@ufomechanic.net>
	<44C8CE76.2090500@trash.net> <44C8D11A.6010502@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44C8D11A.6010502@ufomechanic.net>
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
> * Patrick McHardy wrote, On 27/07/06 15:32:
> 
>>One way to add new stuff is to get your patch into the kernel. Other
>>than that its hard, I agree. ifdefs are not a good idea because
>>following members don't have a constant value anymore.
> 
> 
> Indeed. Layer7 has been around some time, I guess I will attempt to get
> CTA_L7 into that file in the official kernel so that those who use the
> L7 match can get L7 info via contrack /if they want/.

Its not a big deal, but I lean towards not taking such a patch as it
is a) only used by an external match and b) wrong anyway in my opinion.

>>>Some matches (like layer7) store state which is output via
>>>/proc/net/ip_conntrack, I also need it as part of conntrack updates.
>>>I like receiving a conntrack update when the layer7 is detected, for
>>>instance.
>>
>>A match shouldn't do that - what kind of state does it store? Can't
>>you just use your match and combine it with CONNMARK?
> 
> 
> Err... it stores the layer7 pattern that was matched against the
> packets. So you can recognize a flow as being HTTP or SMTP or DNS etc,
> by regexing the packets. It only checks the first few packets in each
> direction of the flow, but having matched, the name of the matching
> pattern becomes part of the conntrack, and the iptables module can then
> test this - so you could set a certain connmark based on the ip
> addresses in combination with some layer7 type; so that HTTP - no matter
> what the port - could all have a higher priority. This is visible from
> /proc/net/ip_conntrack

I actually don't understand the need for the layer7 match at all.
The string match with the fsm textsearch algorithm and some clever
CONNMARK use should be able to do the same.

> The bigger problem which I guess you answered is, how "new" ctnetlink
> attributes should be registered and used; how near an extensible
> framework (which is what I *thought* libnetlink_conntrack was for) and
> how much is just abstraction from the kernel (which it seems *is* what
> libnetlink_conntrack is for).

Its meant for a single purpose - access to the conntrack database.
It is extensible enough for this purpose, we can add new attributes
in the kernel any time.

> This other problem was how much of libnetlink_conntrack I am rewriting
> so that I can vary ever so slightly the conntrack user space tool. I'll
> send my patches on this early next week when I'm through testing on 2.6.17

I'm also not too happy with the current library. I'm doing some work
adding nfnetlink support to libnl, but its far from complete.
