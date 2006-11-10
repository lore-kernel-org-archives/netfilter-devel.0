From: Amin Azez <azez@ufomechanic.net>
Subject: Re: new code; iptables-xml for iptables package.
Date: Fri, 10 Nov 2006 14:59:23 +0000
Message-ID: <455493CB.4020501@ufomechanic.net>
References: <455311B5.5000600@ufomechanic.net>	<455374BE.9050507@trash.net>	<455457C8.4030205@ufomechanic.net>	<45547982.2070606@trash.net>	<45547E94.1040100@ufomechanic.net>	<455483D9.6090003@trash.net>
	<45548CD2.5090407@ufomechanic.net> <45548FC7.1080702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45548FC7.1080702@trash.net>
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

* Patrick McHardy wrote, On 10/11/06 14:42:
> Amin Azez wrote:
>> * Patrick McHardy wrote, On 10/11/06 13:51:
>>
>>> Amin Azez wrote:
>>>
>>>> As for the spacing - guilt - I used the wrong indent options obviously
>>>> :-) fixed now
>>> Thanks, now all I need is a patch to the Makefile to actually compile
>>> this thing :)
> 
> Thanks. Compiling gives me a warning about an unused result of this
> expression:
> 
> static void
> xmlEncode(char *text)
> {
> ...
>                 *text++;
> 
> }
> 
> I assume this should be "text++"?

Oh! Certainly!

In trying to work out why it works at all, I discover that
*text++ is not the same as (*text)++; both of which are wrong in this case.

While we are at it we should make that compare at the top of the same
function be >=127 not >127

Sam
