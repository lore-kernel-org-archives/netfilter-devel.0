From: Amin Azez <azez@ufomechanic.net>
Subject: Re: NF structural changes (was: dangerous?)
Date: Wed, 14 Mar 2007 21:48:03 +0000
Message-ID: <45F86D93.3030004@ufomechanic.net>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
	<45F8637D.3060600@trash.net>
	<Pine.LNX.4.61.0703142207180.1199@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703142207180.1199@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Mar 14 2007 22:05, Patrick McHardy wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> As a result of the "dangerous? Setting mark in nat table" thread, I have 
>>> just drawn this idea of mine down, where:
>>>
>>>  - filter and mangle tables are merged
>>>       
>> We need to preserve compatibility (meaning we must keep the rerouting
>> in mangle), so I don't see the advantage over simply removing the
>> restrictions to mangle.
>>     
>
> I think I kept that, did not I? Basically, I took PacketFlow-new, and
> removed the filter table - which leaves rerouting working, and turned the
> mangle into a filter/mangle (which automatically satisfies the 2nd point).
> Or could you please enlighten me a bit what exactly you meant?
>
>   
I think its fine. I still miss filter/mangle after nat on pre-routing 
and re-suggest merging nat as well.

As for user-compatability, introduce a new character as a legal chain 
name, maybe @ and then let:
iptables -t XXX -[AID] YYY
refer to chain YYY@XXX
and let there be a global table whose contents when flushed default to:
-A PREROUTING -j PREROUTING@mangle
-A PREROUTING -m ctstate --ctstate new -j PREROUTING@nat
etc

Thus the old framework can easily be represented but a single global 
table can be used instead for those who can (or insist on) managing it.

>>>  - filtering comes early, even before nat
>>>    (so that, for example, packets do not needlessy be MARKed, mangled,
>>>       
>> etc.)
>>
>> Would probably make life easier (no more -m conntrack --ctorigdst),
>>     
>
> --ctorigdst is still needed (or at least, it's a benefit), in the
> filter/mangle-INPUT box and filter/mangle-POSTROUTING.
>   
it's also very useful. We also need a ctstate match to decide which ct 
flow a packet is from.
>
> Let's start a new netfilter that can coexist [at the Kconfig level] with
> what people know, therefore making them aware of changes. ("You choose
> CONFIG_NETFILTER2, you know your scripts will break.") Perhaps call it
> CONFIG_PKTTABLES ;-)
>
>   
hmmm, yeah, I've been talking about preserving the user interface, but 
you are right that the different targets and matches have a kernel 
interface that may change. (I'm thinking of nat as was recently hinted). 
But I'm hoping that if the global table has a rich enough context 
(available data and actions) that it can fake the environment of a 
target from the global table.

But at least lets merge mangle and filter in the medium term (and put 
one after nat on prerouting?)

Sam

Sam
