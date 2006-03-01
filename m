From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Tue, 28 Feb 2006 21:57:47 -0500
Message-ID: <BAY109-DAV96ADAFAB4170550F4A52FB3F40@phx.gbl>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com><BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl><44001CDD.3030305@trash.net><BAY109-DAV1A4C43C331B9AEBC1F22EB3F00@phx.gbl>
	<4400A541.9080901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
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


----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Cc: <netfilter-devel@lists.netfilter.org>; "Greg Scott" 
<GregScott@InfraSupportEtc.com>
Sent: Saturday, February 25, 2006 1:43 PM
Subject: Re: New H.323 conntrack & NAT helper module

Hi, Patrick,

Thank you for your patches, they are very helpful. I've already applied the 
patch for
excessive stack usage. For the patch of adding support for non-linear SKBs, 
I admit
it is even a bug if there is no support for non-linear SKBs,  but I have 
some different
idea for the checksum method.

> Add support for non-linear SKBs. I know switching to
> ip_nat_mangle_{tcp,udp}_packet is less efficient because it checksums
> the packet on each call, but that can be fixed seperately by switching
> it to incremental checksumming.

Imagine a Setup signal with 30 fast-start entries (this is not unusual for 
Gnomemeeting
and OpenPhone), if you use ip_nat_mangle_tcp_packet, you will have to call 
it 45
times. For a RRQ message, you will possible call ip_nat_mangle_udp_packet 
more
than 10 times if it contains many signal addresses. You can use incremental
checksumming, but I'm still worrying about the efficiency. This is why I 
prefer to use
a counter (please see the last paragraph) to track modifications and do the
checksum only once.

> Change the H.323 helper to support non-linear skbs similar to the other
> helpers. This has two additional positive side-effects:

> - skb_writable was broken as it always tried to reload the data pointer 
> with
>   an assumed TPKT payload, even for H.225 RAS packets.

This can be fixed by seeing the protocol.

> - we can use the regular NAT packet mangling functions and get rid of the
>   manual checksumming

>
> Well, thank you, This is really great work. I forgot one small issue:
> there seems to be some debugging-leftover, the functions registering
> expectations add up the number of registered expectations and return
> that value, but nobody uses it. If there are no plans for using it,
> I would prefer to have it removed.
>

The return is actually a modification track counter. If a function 
successfully changed a
packet, the counter will be increased. Finally, if the counter is positive, 
the packet will be
checksumed; if it's 0, no changes; if negative, error happened.


Best regards,
Jing Min Zhao
