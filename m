From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RFC: netfilter: xtables: add CT target
Date: Tue, 19 Jan 2010 11:27:25 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1001191115160.3138@blackhole.kfki.hu>
References: <4B5575CB.5050207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:35131 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab0ASK10 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 05:27:26 -0500
In-Reply-To: <4B5575CB.5050207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 19 Jan 2010, Patrick McHardy wrote:

> The attached two patches add a 'CT' target to specify parameters
> used during conntrack creation. This can be used to manually attach
> a helper to a connection. A couple of patches I'm still working
> on will additionally use this for the "conntrack zones" classification.
> 
> I'm wondering if anyone has further ideas of parameters that might
> make sense to support. We could for example move parameters like
> sip_direct_signalling and sip_direct_media into the helper structure
> and allow to set them dynamically for each connection. Or perhaps
> selectively enable netlink events.

Selectively enabling netlink events (not only per connection but per event 
type) would be cool! Last year I used the CONNMARK target for that purpose 
- maybe it fits better to the CT target.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
