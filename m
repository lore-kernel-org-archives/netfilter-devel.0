From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bridge netfilter defered hooks
Date: Thu, 08 Jun 2006 09:15:52 +0200
Message-ID: <4487CEA8.8060701@trash.net>
References: <448051F3.1070509@trash.net>	<1149267610.3021.11.camel@localhost.localdomain>
	<448072FC.3060902@trash.net> <44809B1C.2010907@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <44809B1C.2010907@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Patrick McHardy wrote:
> 
>>Thats what I meant by "iptables+mark". You can combine iptables
>>specific matches by marking matching packets, then match on the
>>mark with ebtables (or the other way around for incoming packets).
> 
> 
> IIRC the mark has only 32 bits. Not so long ago, I was using 30 bits
> of that in my firewalling rules on a bridge-router. I might have
> squeezed the physdev match in the remaining 2 bits, but I'm not
> sure. I do admit the setup was fairly uncommon (bridging and
> double nat with only one machine).

Yes, its getting a bit tight in there, but so far in all setups I've
seen it was possible to get along with the 32 bits using masks or
reusing bits after they are no longer needed. I guess we'll have to
wait and see ..
