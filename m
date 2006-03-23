From: Patrick McHardy <kaber@trash.net>
Subject: Re: Per-client NAT routing -- possible?
Date: Thu, 23 Mar 2006 19:26:49 +0100
Message-ID: <4422E869.8020108@trash.net>
References: <51e5f6120603220916v3c536afamdb3023563866397d@mail.gmail.com>	<51e5f6120603221849p2da80ec5nb49ae81d7ae93d8f@mail.gmail.com>
	<44227366.60106@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44227366.60106@ufomechanic.net>
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
> Jeremy Elson wrote:
> 
>> [ Sent before I subscribed - I think it was silently dropped.
>> Apologies if you get 2. ]
>>
>>
>> Hi,
>>
>> I'm trying to set up a Linux box as a NATting router.  But here's the
>> trick: my box's external interface is on a LAN that has a whole bunch
>> of routers on it, any of which can be used to access the Internet.
>> I'm trying to figure out how to configure iptables so that the NAT box
>> selects the router to use based on client IP address (i.e., the IP
>> address on the inside interface).
>>
>> I've been tinkering with a command like this:
>>
>> iptables -t nat -A POSTROUTING -i $INTERNAL_CLIENT_IP -o
>> external-iface0 -j SNAT --to $EXTERNAL_ROUTER_IP
>>
>> ...but it seems that --to controls the new source address given to the
>> packet (i.e., the router's outside-interface IP), and not the
>> destination to which the NATted packet is sent.
>>
>> Could someone please point me in the right direction?  Or is this not
>> possible?
> 
> 
> I think you can use ipt_route to select the output gateway or interface,
> NAT should then work after that.

That sounds rather hackish. The normal way to do something like that
is to use normal multipath routes and, if NAT to different IPs needs
to be used, CONNMARK to bind connections to one of the paths.
