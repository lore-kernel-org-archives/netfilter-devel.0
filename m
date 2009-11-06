From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][BRIDGE-NETFILTER] fix REJECT for bridged traffic
Date: Fri, 06 Nov 2009 18:45:19 +0100
Message-ID: <4AF460AF.5000201@trash.net>
References: <4AF1D08C.2030907@pandora.be> <4AF2E21B.4050801@trash.net> <4AF32544.2060709@pandora.be> <4AF448C8.80701@trash.net> <4AF45DFB.3070606@pandora.be> <4AF45E91.9050203@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34423 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbZKFRpQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:45:16 -0500
In-Reply-To: <4AF45E91.9050203@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Bart De Schuymer wrote:
>> Patrick McHardy schreef:
>>> Yes, we need to save it at some point. My idea was that we might be able
>>> to save it in PREROUTING instead of POSTROUTING and only do
>>>
>>> nskb->nf_bridge = nf_bridge_get(oskb->nf_bridge)
>>>
>>> in ipt_REJECT and probably also the ICMP code. MAC NAT could be handled
>>> by updating the bridge info simultaneously.
>>>
>>>   
>> The code creates a new skbuf and the correct source MAC address is lost
>> if you don't attach it to the skbuf at that time.
> 
> That's what I'm doing above.
> 
>> How will you know in
>> PREROUTING what SMAC to use if you didn't save it when you created the
>> skbuf?
> 
> I'm not sure I understand what you're getting at. The above
> line of code would do exactly that, attach the nf_bridge
> data from the original packet to the newly created one.
> But for this to work we need to make sure its valid in all
> hooks, hence my suggestion to save it in PREROUTING instead
> of POSTROUTING.

This patchTo demonstrate the idea
