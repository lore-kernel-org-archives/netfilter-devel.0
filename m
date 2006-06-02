From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Bridge netfilter defered hooks
Date: Fri, 02 Jun 2006 22:10:04 +0200
Message-ID: <44809B1C.2010907@gmx.net>
References: <448051F3.1070509@trash.net>	<1149267610.3021.11.camel@localhost.localdomain>
	<448072FC.3060902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <448072FC.3060902@trash.net>
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

Patrick McHardy wrote:
> Bart De Schuymer wrote:
>> Op vr, 02-06-2006 te 16:57 +0200, schreef Patrick McHardy:
>>
>>> The main question is if the feature that causes all this trouble
>>> (output port matching within iptables) really is useful at all.
>>> It is not needed for filtering based on the output port of a
>>> bridge, this can be done using ebtables and iptables+mark if
>>> necessary.[...]
>>
>> Sounds reasonable. You of course missed the combination of any of the
>> iptables specific matches/targets with the physdev match.
> 
> Thats what I meant by "iptables+mark". You can combine iptables
> specific matches by marking matching packets, then match on the
> mark with ebtables (or the other way around for incoming packets).

IIRC the mark has only 32 bits. Not so long ago, I was using 30 bits
of that in my firewalling rules on a bridge-router. I might have
squeezed the physdev match in the remaining 2 bits, but I'm not
sure. I do admit the setup was fairly uncommon (bridging and
double nat with only one machine).

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
