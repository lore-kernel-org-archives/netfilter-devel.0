From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ebtables hook order anomaly
Date: Tue, 25 Mar 2008 14:49:59 +0100
Message-ID: <47E90307.2060802@trash.net>
References: <925A849792280C4E80C5461017A4B8A226A01E@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep31-int.chello.at ([62.179.121.49]:57068 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYCYNuE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:50:04 -0400
In-Reply-To: <925A849792280C4E80C5461017A4B8A226A01E@mail733.InfraSupportEtc.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg Scott wrote:
>> Indeed, on output bridge netfilter will run after IPv4 netfilter.
>> Does that explain things?
> 
> Well, not really.  2.6.23-2 behaves differently than 2.6.18.  My
> ebtables marks get set and read by iptables in 2.6.18.  iptables does
> not see them in 2.6.23.
> 
> It could be something in the order of execution changed.  I'm using
> RedHat kernels right now and I know they tweak the kernels a little bit.
> But surely the RedHat guys would not change something this fundamental?


No, that was us :) Bridge-netfilter used to defer the IPv4 OUTPUT
and POSTROUTING hook until the outgoing bridge port was determined
by the bridge code. This "feature" was removed because it broke
all kinds of things, now the order matches the layering and IPv4
hooks are always processed entirely before bridging.

> I set my ebtables mark for outbound packets in two places - in the
> OUTPUT chain and the FORWARD chain.  I was looking mostly at the
> ebtables FORWARD chain for packets that pass thru the box.  I set the
> mark in ebtables FORWARD and OUTPUT.  Iptables POSTROUTING needs to see
> them so it knows to MASQUERADE.  Otherwise, things get really weird.  :)
> iptables sees the marks in 2.6.18, but does not see them in 2.6.23.  
> 
> I have a couple of 2.6.23 systems here and I can brew up a 2.6.18 fc6
> system later on for testing if needed.  (All the 2.6.18 stuff I have
> built up right now is in production.)  I can set up some tests similarly
> to Jan's testing from last night for packets passing through the box.  
> 
> Or if there's a better way to do this, I'm open.  

For routed packets you can't make any decisions in iptables based
on the outgoing bridge port, thats only possible for purely bridged
traffic.
