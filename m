From: Amin Azez <azez@ufomechanic.net>
Subject: Re: aggg Re: libnfnetlink_conntrack encapsulation issues
Date: Thu, 27 Jul 2006 16:16:03 +0100
Message-ID: <44C8D8B3.5070608@ufomechanic.net>
References: <44C89B2E.1080401@ufomechanic.net>	<44C89DD8.7030103@ufomechanic.net>	<44C8C6E1.8010004@trash.net>	<44C8CC58.1080909@ufomechanic.net>	<44C8CE76.2090500@trash.net>
	<44C8D11A.6010502@ufomechanic.net> <44C8D4C6.9060100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44C8D4C6.9060100@trash.net>
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

* Patrick McHardy wrote, On 27/07/06 15:59:
> Amin Azez wrote:
>> * Patrick McHardy wrote, On 27/07/06 15:32:
>>
>>> One way to add new stuff is to get your patch into the kernel. Other
>>> than that its hard, I agree. ifdefs are not a good idea because
>>> following members don't have a constant value anymore.
>>
>> Indeed. Layer7 has been around some time, I guess I will attempt to get
>> CTA_L7 into that file in the official kernel so that those who use the
>> L7 match can get L7 info via contrack /if they want/.
> 
> Its not a big deal, but I lean towards not taking such a patch as it
> is a) only used by an external match and b) wrong anyway in my opinion.

I would lean towards not taking it too, but how else to get
libnetlink_conntrack to work with arbitrary conntrack attributes?
And taking the general case of ct_extend? make_atom is my favoured
solution but it might spoil the _XXX_MSG_MAX idea, or we would need
multiple atom pools.

> I actually don't understand the need for the layer7 match at all.
> The string match with the fsm textsearch algorithm and some clever
> CONNMARK use should be able to do the same.

I heard a layer7 guy saying a similar thing about the string match. I
think. :-) It's not like I'm trying to match a particular layer7
protocol, I'm trying to match about a hundred, and managing regex's is
easy. Anyway.... I'm not for making everyone like each-others favourite
modules; I'm already overusing the mark (IMHO) although some use it
more, it really is a boon to have the odd extra conntrack attribute
/that I need/

> Its meant for a single purpose - access to the conntrack database.
> It is extensible enough for this purpose, we can add new attributes
> in the kernel any time.

thats the bit I'm also trying to do..

I've also extended connmark so that each flow can have its own mark -
which sort of helps traffic shaping each direction differently.
Naturally of course, I need to get the extra marks from the conntrack
database to userspace, along with the original mark. (For compatability
there are now 3 marks, the traditional mark, and one set for each direction)

Sam
