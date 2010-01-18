From: Patrick McHardy <kaber@trash.net>
Subject: Re: Two patches for nf_conntrack_sip
Date: Mon, 18 Jan 2010 19:13:59 +0100
Message-ID: <4B54A4E7.6020200@trash.net>
References: <20100116103640.GB11547@goonies.be> <4B541272.8040001@trash.net> <20100118174919.GD11547@goonies.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Greg Alexander <greqcs@galexander.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60482 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0ARSOH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:14:07 -0500
In-Reply-To: <20100118174919.GD11547@goonies.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg Alexander wrote:
> Thank you for your response.
> 
>> Well, it depends, there are a lot of setups where the registrar is
>> also proxying RTP. But the main reason why this defaults to 1 is
>> because netfilter usually doesn't allow expectations for addresses
>> not belonging to the connection since that allows to poke holes to
>> arbitrary peers into the firewall. So people should think before they
>> enable this and adjust their ruleset to restrict this as far as
>> possible.
> 
> I agree that it has a potential to be a minor security risk.  However,
> the entire point of NAT is to allow packets through a firewall.  If an
> interior host signals that it wants to accept foreign packets on a port,
> NAT should not hamper him from it.

No, NAT is only responsible for address translation, and in fact it
isn't even involved in this decision. The connection tracking helper
(which can also be used without NAT) creates expectations, the expected
connections have to be permitted by the ruleset. The helper doesn't
drop or allow anything, all this parameter does is control how the
expectations are set up (wildcards or no wildcards).

> This is a very prominent problem.  Search google: people everywhere are
> whining about this, though most of them don't know the cause.
> sip_direct_media=1 simply does not work with the majority of common SIP
> scenarios and does not conform to the standard.  We have three options:
> (A) unsatisying user experience, (b) informing every noob that they need
> to set sip_direct_media=0 for their phone to work, or (C) fixing the
> default. Option (A) rules supreme today.

I've seen quite a few of those bug reports myself, and in all but one
case it was actually people using the old version of the helper, which
didn't work properly at all (and didn't support these parameters).

> Should defaults reflect the most secure possible setting, or should they
> reflect the most commonly-used setting?  We can have the best of both
> worlds, as the default is to leave nf_conntrack_sip/nf_nat_sip out of the
> kernel entirely -- secure wins by default.  Any user who goes to the
> effort to include these modules does so because they want their NAT to be
> able to handle SIP connections.  My SIP-conforming device opens a UDP
> socket and accepts packets from *.*.*.*:* so I don't see why my
> SIP-conforming NAT wouldn't also accept packets from *.*.*.*:*.

Mainly because conntrack helpers track all connections to a specific
port, so without taking care, people can easily circumvent your ruleset.
If SIP tracking would be configured for specific registrar I'd probably
have used the more permissive mode by default, but unfortunately this is
not how conntrack works.

> And thanks for informing me of early media.  I was not aware SIP would
> allow that, but it makes sense since really only one side of the
> conversation really needs to provide an SDP anyways.
> 
>>> An observation about SIP failure modes.  I have the impression that
>>> nf_conntrack_sip almost never intervenes successfully.  With my
>>> particular phone/provider, it manifest in being able to receive calls but
>>> not place them.  It turns out this is because my telco uses two totally
>>> different servers for incoming and outgoing calls.  Coincidentally, the
>>> one that is used for outgoing calls blindly sends media packets to the
>>> address that I tell it to.  However, the one that is used for incoming
>>> calls is specifically aware of broken NAT and sends messages to the UDP
>>> port that you send from, regardless of what packet was specified in the
>>> header.  In effect, they ignore the port number that is specified in the
>>> SIP transaction because it is so often wrong (due to NAT).
>> That's usually caused by your client inserting headers that are not
>> translated, making the remote side aware that the peer is behind a NAT
>> and enabling workarounds. Have a look at the outgoing packets and look
>> for untranslated addresses or port numbers. Fixing those should fix this
>> behaviour.
> 
> Fixing those was the first thing I did and is what resulted in the
> off-by-one patch to handle compact SIP.  I think you may not be aware of
> this particular hack, so I will explain it in more detail.  With
> sip_direct_media=1 this is what happens.
> 
> When I receive an incoming call, I get an SDP payload indicating I am to
> exchange media with hostA:portA, and I send an SDP payload indicating I
> am at hostB:portB.  hostB:portB in this case happens to be correct on the
> external interface (the nat mapping is correct), the only trouble is that
> the conntrack expectation is for the SIP host instead of hostA.
> 
> So the RTP streams on the external interface look like this:
>    hostA:portA -> hostB:portB - doesn't match expect, ignored by NAT (dropped)
>    hostB:1024 -> hostA:portA - doesn't match expect, default NAT mapping
>               gets port 1024 instead of portB.
>    hostA:portA -> hostB:1024 - remote host has detected that I am not using
>               portB, and silently switched ports
>    hostB:1024 -> hostA:portA
>    hostA:portA -> hostB:1024 ... the communication proceeds correctly
> 
> However for outgoing calls, the remote SDP uses a different hostA at a
> different data center, and that conversation goes like this:
>    hostA:portA -> hostB:portB - doesn't match expect, dropped
>    hostB:1024 -> hostA:portA - port 1024 instead of portB
>    hostA:portA -> hostB:portB
>    hostB:1024 -> hostA:portA ....
> Since the remote host is always sending to portB while NAT has assigned
> me 1024 by default, one side of the conversation is dropped.
> 
> This is a result of sip_direct_media=1 interacting with two different
> remote RTP peer implementations, even after all of the SIP/SDP fields
> have been correctly modified by nf_nat_sip.  In the first case, the
> connection works even though the sip_direct_media=1 setting is wrong for
> my scenario.  If you want, I can send you URLs for many threads containing
> end-user complaints that exactly match this scenario, most of which went
> unresolved.  I am using Gizmo5, which is quite popular.

So does it work with sip_direct_media=0?
