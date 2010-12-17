From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Fri, 17 Dec 2010 11:02:41 +0100
Message-ID: <4D0B3541.2090501@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr> <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu> <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk> <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr> <4D0A9F54.8080602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Jesper Dangaard Brouer <hawk@diku.dk>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	tgraf@redhat.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D0A9F54.8080602@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 17/12/10 00:23, Patrick McHardy wrote:
> Am 16.12.2010 13:51, schrieb Jan Engelhardt:
>> On Thursday 2010-12-16 10:57, Jesper Dangaard Brouer wrote:
>>
>>> Cc.ed Thomas Graf (tgraf@redhat.com), Thomas presented some interesting 
>>> ideas on netlink error-codes and strings during NetConf 2010, see:
>>>
>>> http://vger.kernel.org/netconf2010.html 
>>> http://vger.kernel.org/netconf2010_slides/tgraf_netconf10.odp
>>
>> The idea is appending an error string is ok for Netlink as a protocol
>> (specification-wise), but the size constraints of the skbuffs in the
>> Linux may make its practical implementation a little harder. "Half of
>> the packet" is already used for the original request message, and
>> cramming an extra error string may bust the space.
>> It also does not look very netlinky to not use nlattrs ;-)
> 
> I agree, error strings don't look like a viable solution to me,
> they are basically impossible to interpret by an application,
> you run into localization issues and so on.
> 
> I'd suggest to return an errno value and the attribute causing
> the error, possibly also the value (we append the original message
> anyways, but in case of lists it might be hard to locate the specific
> attribute). The harder cases are when a combination of multiple
> attributes are responsible for the error, but still, the application
> has to understand the kernel interpretation anyways, so I'd simply
> return the errno and all attributes responsible. Leave interpretation
> up to userspace.

I'd also prefer an int. We can define the meaning of the error numbers
in the protocol header file.
