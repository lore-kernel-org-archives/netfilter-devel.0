From: Amin Azez <azez@ufomechanic.net>
Subject: Re: priv_data patch
Date: Tue, 15 Aug 2006 09:27:40 +0100
Message-ID: <44E1857C.80008@ufomechanic.net>
References: <44E07BCD.8030206@trash.net>	<20060814142559.GS7194@kriss.csbnet.se>	<44E08946.1040105@trash.net>	<20060814152026.GU7194@kriss.csbnet.se>	<44E09693.9000606@trash.net>	<20060814160443.GX7194@kriss.csbnet.se>	<44E0A132.6040709@trash.net>
	<20060814165549.GC7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20060814165549.GC7194@kriss.csbnet.se>
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

* Joakim Axelsson wrote, On 14/08/06 17:55:
> 2006-08-14 18:13:38+0200, Patrick McHardy <kaber@trash.net> ->
>> Joakim Axelsson wrote:
>>> 2006-08-14 17:28:19+0200, Patrick McHardy <kaber@trash.net> ->
>>>
>>>>> Please have a look here for 4 modules "needing" this patch:
>>>>> http://www.gozem.se/~gozem/netfilter/
>>>> Please post your examples to the list.
>>>>
>>>
>>> In which format? As a full patch for the kernel or something that fits in
>>> pom-ng? The current code works for 2.4 and early 2.6. I don't want to spend
>>> time porting it into "wrong" API now when we are discussing priv_data to be
>>> or not to be :-)
>> I'm mostly interested in the way you wish to use it, so I can better
>> judge whether this change is worth doing or not.
>>
> 
> The change is NOT worth it if we can't keep the priv_data pointer between
> changes of unrelated rules. I better use a global list instead as condition
> is using today.


Or, anticipating the future, why not let the current implementation of
priv_data be used to cache the entry from the global list. When
priv_data is satsifactory the global list can go. Why not let priv_data
manage the "backup" global list while it is needed, then client modules
of priv_data don't even need to know about this; which is better than
client modules all implementing their own global list.

I'm saying that while a global list may currently be needed we can still
encapsulate it in the priv_data api and still get MOST of the benefit
now and easily get all of the benefit later.

Sam
