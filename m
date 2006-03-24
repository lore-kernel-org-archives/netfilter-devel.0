From: Patrick McHardy <kaber@trash.net>
Subject: Re: Per-client NAT routing -- possible?
Date: Fri, 24 Mar 2006 13:58:56 +0100
Message-ID: <4423ED10.6060008@trash.net>
References: <51e5f6120603220916v3c536afamdb3023563866397d@mail.gmail.com>	<51e5f6120603221849p2da80ec5nb49ae81d7ae93d8f@mail.gmail.com>	<44227366.60106@ufomechanic.net>
	<4422E869.8020108@trash.net> <4423E4E2.9030303@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <4423E4E2.9030303@ufomechanic.net>
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
> Patrick McHardy wrote:
> 
>> Amin Azez wrote:
>>
>>>> Could someone please point me in the right direction?  Or is this not
>>>> possible?
>>>
>>>
>>>
>>> I think you can use ipt_route to select the output gateway or interface,
>>> NAT should then work after that.
>>
>>
>>
>> That sounds rather hackish. The normal way to do something like that
>> is to use normal multipath routes and, if NAT to different IPs needs
>> to be used, CONNMARK to bind connections to one of the paths.
> 
> 
> Respecting your experience and acknowledging my ignorance, but THAT
> seems like the hacky way to me. I realise most of the world thinks I'm
> wrong, I merely offer this insight into the strangeness of the "other"
> persons mind.
> 
> I guess I do it this way because I do a lot of bridging.

I guess its a matter of taste which way you prefer, but one argument
against the route target is that it replicates lots of code from
the IP layer, which is never a good idea and most likely already
out of date. From a short look, it seems like it doesn't work with
IPsec for example.
