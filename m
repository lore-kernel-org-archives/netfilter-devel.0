From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Thu, 16 Dec 2010 16:09:01 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012161604220.25887@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>  <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>  <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>  <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
 <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>  <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr> <1292507013.3395.19.camel@lsx> <alpine.DEB.2.00.1012161535080.6557@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Thomas Graf <tgraf@redhat.com>,
	Jesper Dangaard Brouer <hawk@diku.dk>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012161535080.6557@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thursday 2010-12-16 15:47, Jozsef Kadlecsik wrote:
>> 
>> Thinking of netlink protocols in general and netfilter in specific,
>> maintaining a list of reserved error codes for each subsystem/target/
>> module will result in an unbearable pain if the error codes are not
>> separated into individual namespaces for each module.
>> 
>> That would in turn require each module to define a unique number or
>> some form of namespace resolution mechanism which does not help to keep
>> things simple.
>> 
>> This is the main reason why I advocate the use of error strings.
>
>But why error codes looks complicated? Netlink already supports it and 
>it's simple to separate them:
>	errcode < 256	generic errors
>256 <=	errcode < 512	generic netfilter specific errors
>512 <=	errcode		table/match/module specific errors

Actually, <4096 is reserved for the generic system errors (Exxx).

The specific issue here however is that you cannot easily delegate
the space >=512 to modules, so it's probably best if we don't try.

>>Do we *really* need internationalization for error messages on this
>>level? Primarily userspace should be in charge of checking for all kinds
>>of erroneous user input and produce meaningful context based,
>>translatable error messages. Error messages produced by the kernel
>>should be the exception and not a substitute for proper userspace error
>>handling.
>
>Netlink based protocol is the path to internationalization. Netlink based 
>protol leads to usable library. Library leads to gui. Gui leads to 
>internationalization. ;-)

On the contrary:
"Users leads to guis, guis lead to requests, requests lead to libraries,
libraries lead to netlink.
Doesn't make sense? Ask SUN!"
