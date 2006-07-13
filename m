From: "bdschuym@pandora.be" <bdschuym@telenet.be>
Subject: Re:  RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 12:56:45 +0000
Message-ID: <W952101659891521152795405@hoboe1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>, "Philip Craig" <philipc@snapgear.com>
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


>----- Oorspronkelijk bericht -----
>Van: Patrick McHardy [mailto:kaber@trash.net]
>Verzonden: donderdag, juli 13, 2006 10:36 AM
>Aan: 'Philip Craig'
>CC: 'Netfilter Development Mailinglist', 'Bart De Schuymer', 'Tom Eastep'
>Onderwerp: Re: RFC: Disable defered bridge hooks by default
>
>On Thu, 13 Jul 2006, Philip Craig wrote:
>
>> Patrick McHardy wrote:
>>> On Wed, 12 Jul 2006, Philip Craig wrote:
>>>
>>>> Patrick McHardy wrote:
>>>> Would it be possible to call the bridging code from the iptables
>>>> forward/output hooks, store the result somewhere, and then when the
>>>> packet is passed to the bridge device, just use the stored result?
>>>> So fix the problem by calling bridging early, instead of deferring
>>>> iptables?  I'm not sure if this could handle packets that need to
>>>> be sent out multiple ports.
>>>
>>> No, it couldn't. Its questionable behaviour to do this anyway, think
>>> about something you REJECT without looking at the output port - you
>>> will reject once for each output port. The entire idea of using
>>> iptables from the bridge code seems flawed to me. Conntrack might
>>> also get very confused under certain cicurstances.
>>
>> These are also problems for purely bridged packets.  br_flood calls
>> __br_forward for every port, which calls the bridge forward hook, and
>> that passes the packet on to the ipv4 forward hook.  Should this be
>> changed so that the ipv4 forward hook is called earlier, and filtering
>> on output port is never possible?
>
>As I already mentioned in this thread, I believe the concept of calling
>iptables from briding is flawed. We have ebtables to do filtering within
>a bridge. But this is getting slightly off-topic.

ebtables can't do things like stateful IP firewalling. IMO, things like 
transparent stateful firewalling are way too cool to just throw out of Linux 
because it troubles iptables somewhat in special cases.

cheers,
Bart
