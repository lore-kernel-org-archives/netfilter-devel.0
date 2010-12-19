From: Dennis Jacobfeuerborn <dennisml@conversis.de>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 19 Dec 2010 16:20:05 +0100
Message-ID: <4D0E22A5.8090808@conversis.de>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D0E0E2A.3090604@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 12/19/2010 02:52 PM, Mr Dash Four wrote:
>
>>> By 'something' I mean either omission of the protocol, or 'all' to be
>>> specified instead of the protocol to mean no matching on protocol would be
>>> made (in other words the protocol to be disregarded). This will be
>>> especially
>>> useful for sets with quite a few number of members and will avoid
>>> unnecessary
>>> duplication - as things stand I have to add the same number of members for
>>> both tcp and udp protocols when I don't need any protocol matching -
>>> just the
>>> subnets and port numbers I specified. Is this doable?
>>
>> Use set types without port sub-part, like hash:net or hash:ip, etc.
>> I don't really see why you would want to use a type with port and then
>> ignore it.
> I don't want to ignore the port - that stays (I need it to do the
> matching). I want to ignore the protocol, but keep the subnet and port
> number matches.
>
> As I already mentioned, I see the need to register 2x as many members to a
> particular set just to get the match required (i.e. ignore the protocol)
> unnecessary when the alternative is to a) do not use protocol definition;
> or b) use another word (I suggested 'all') to ignore the protocol match and
> just use the subnet and port number(s) instead.
>
> Wouldn't you agree that this is a better solution than registering twice as
> many members in a particular set in order to get the match I need?

Given that ports are only meaningful in the context of a protocol I don't 
think that makes sense. If I want to block traffic to "port 80" in order to 
prevent access to a web server then what I'm rally saying is that I want 
top block traffic to "tcp port 80". There is no point in blocking udp port 
80 too. While there are some servers out there that use connections on the 
same port on both udp and tcp (e.g. DNS) these are the exception and should 
still be handled explicitly by defining rules for both protocols separately.
Why would you want to match a port for all protocols? Do you have a 
specific example for that?

Regards,
   Dennis
