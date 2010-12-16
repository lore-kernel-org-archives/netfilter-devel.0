From: Patrick McHardy <kaber@trash.net>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Fri, 17 Dec 2010 00:23:00 +0100
Message-ID: <4D0A9F54.8080602@trash.net>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr> <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu> <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk> <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, tgraf@redhat.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Am 16.12.2010 13:51, schrieb Jan Engelhardt:
> On Thursday 2010-12-16 10:57, Jesper Dangaard Brouer wrote:
> 
>> Cc.ed Thomas Graf (tgraf@redhat.com), Thomas presented some interesting 
>> ideas on netlink error-codes and strings during NetConf 2010, see:
>>
>> http://vger.kernel.org/netconf2010.html 
>> http://vger.kernel.org/netconf2010_slides/tgraf_netconf10.odp
> 
> The idea is appending an error string is ok for Netlink as a protocol
> (specification-wise), but the size constraints of the skbuffs in the
> Linux may make its practical implementation a little harder. "Half of
> the packet" is already used for the original request message, and
> cramming an extra error string may bust the space.
> It also does not look very netlinky to not use nlattrs ;-)

I agree, error strings don't look like a viable solution to me,
they are basically impossible to interpret by an application,
you run into localization issues and so on.

I'd suggest to return an errno value and the attribute causing
the error, possibly also the value (we append the original message
anyways, but in case of lists it might be hard to locate the specific
attribute). The harder cases are when a combination of multiple
attributes are responsible for the error, but still, the application
has to understand the kernel interpretation anyways, so I'd simply
return the errno and all attributes responsible. Leave interpretation
up to userspace.

> On Wed, 15 Dec 2010, Jozsef Kadlecsik came about with:
>>
>>> I have got a three-level error coding in my mind: general, standard 
>>> error codes (ENOMEM, EPERM, etc.), general netfilter specific ones 
>>> (like NFXTE_HOOKMASK_NOT_ADHERED) and table/match/target specific 
>>> ones.
>>>
>>> But I do realize that it's much easier (and therefore quite tempting) 
>>> to construct the full error message in kernel space and just send it 
>>> back. However, that'd make quite hard to support internationalization.
> 
> It's not like those strings change all that much.
> 
> 
>> To support internationalization, we could just add an error-number-code 
>> in front of the constructed error message?
> 
> Buying us what? If you change the string, but the gettext lookup is 
> based upon a number, you will get an outdated translation, which is not 
> nice either. IMHO: Better an English message than an inaccurate message.

Forget about strings, any error returned by the kernel should not only
be suitable for interpretation by a human, but also by an application.
