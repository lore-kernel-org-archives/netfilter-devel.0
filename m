From: "bdschuym@pandora.be" <bdschuym@telenet.be>
Subject: Re:  Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in
    2.6.22.6
Date: Wed, 07 Nov 2007 11:44:39 +0000
Message-ID: <W352381485970601194435879@nocme1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"Bart De Schuymer" <bdschuym@pandora.be>
To: "Patrick McHardy" <kaber@trash.net>,
	"ron lai" <ronlai@cs.stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:60911 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbXKGLqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 06:46:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>----- Oorspronkelijk bericht -----
>Van: Patrick McHardy [mailto:kaber@trash.net]
>Verzonden: woensdag, november 7, 2007 11:33 AM
>Aan: 'ron lai'
>CC: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org, 'Bart De Schuymer'
>Onderwerp: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
>
>Patrick McHardy wrote:
>I can reproduce this with forwarding between two bridges.
>The reason is that skb->nf_bridge still contains the data
>from the first bridge and so br_netfilter thinks this is
>a bridged packet. I don't know how this is supposed to work,
>but it seems to me that on packets going out a bridge device
>this should be reset in case it originates from a different
>bridge (actually I think it should be reset unconditionally
>but that would probably break bridged DNAT).
>
>Bart, what do you think about changing this:

(sorry for the webmail mess)
I think that would work. It shouldn't be reset unconditionally at that point since we allow IP dnating of bridged packets (bridged-and-DNAT'ed case). Another solution I think is this:
in br_nf_post_routing():
change
if (!nf_bridge)
to
if (!nf_bridge || !(nf_bridge->mask & BRNF_BRIDGED_DNAT))

This regression was introduced when the ip_out sabotage stuff was removed. br_nf_post_routing should now only consider bridged IP packets.

cheers,
Bart



