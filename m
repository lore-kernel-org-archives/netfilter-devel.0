From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH v2 next] netfilter: bridge: optionally set indev to vlan
Date: Thu, 12 Apr 2012 20:12:39 +0200
Message-ID: <4F871B17.1070800@pandora.be>
References: <1334047336-31143-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:48740 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab2DLSMr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:12:47 -0400
In-Reply-To: <1334047336-31143-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 10/04/2012 10:42, Florian Westphal schreef:
> if net.bridge.bridge-nf-filter-vlan-tagged sysctl is enabled, bridge
> netfilter removes the vlan header temporarily and then feeds the packet
> to ip(6)tables.
>
> When the new "bridge-nf-pass-vlan-input-device" sysctl is on
> (default off), then bridge netfilter will also set the
> in-interface to the vlan interface; if such an interface exists.
>
> This is needed to make iptables REDIRECT target work with
> "vlan-on-top-of-bridge" setups and to allow use of "iptables -i" to
> match the vlan device name.
>
> Also update Documentation with current brnf default settings.
>
> Signed-off-by: Florian Westphal<fw@strlen.de>

Your patch is ok for me.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

