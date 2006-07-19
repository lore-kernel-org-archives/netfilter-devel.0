From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 19 Jul 2006 19:15:13 +0200
Message-ID: <44BE68A1.4070609@trash.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net>	<44B493BC.5010302@snapgear.com>
	<Pine.LNX.4.64.0607130937580.15827@x2>	<44B654AF.2080401@ufomechanic.net>
	<Pine.LNX.4.64.0607131646090.15827@x2>
	<44B666C5.8040603@ufomechanic.net> <44BE5F9E.8020603@trash.net>
	<44BE624E.5080307@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44BE624E.5080307@ufomechanic.net>
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
> * Patrick McHardy wrote, On 19/07/06 17:36:
> 
>>The routing code shouldn't know anything about the bridge FDB.
>>  
> 
> True, I only suggest that the bridge work out what it is going to do
> with the packet just after routing (if any) but before post-routing. I
> can't think of much else that will happen to the packets between
> postrouting and bridge output that would spoil this.
> 
> I wasn't suggesting that bridging and routing modules should peer over
> eachothers shoulders, but rather than defer the hooks we bring forward
> the bridge decision.


But at that point again you can't even be sure if the packet will
finally exit a bridge device. TC action could direct the packet
to a different device from the bridge output queue. There is no
clean solution for this which integrates well with all the other
things Linux networking can do.

>>>I think if ebtables becomes the answer it will just grow to be as big as
>>>iptables with all the extra matches iptables has, just as iptables has
>>>extra -p tcp and -p udp matches.
>>>    
>>
>>Thats where MARK will be useful, but only if the target is available
>>in ebtables. SNAT based on bridge port won't be possible anymore.
>>  
> 
> Yes but the ebtables could get as big as turing machine as the possible
> ebtables actions end up getting encoded into the mark; with such side
> deferred effects as:
> * set dscp to various values
> * set mark (for tc)
> * drop
> 
> all multipled by the number of output ports, so that these actions can
> be taken based on the output port.


Worst case will need some space, but common sense tells me that this is
not what users are doing (DSCP based on bridge output port combined with
criteria only usable within iptables? What for?). Marking for tc can
be done within iptables, and ebtables just needs to encode the output
port in the mark if you really need it (why would you? you have a
seperate device, the bridge port, to do QoS on).

Anyway, I'll submit the patch soon, which gives us at least 6 more month
to work this out.
