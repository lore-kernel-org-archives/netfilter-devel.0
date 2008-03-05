From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netlink socket filtering
Date: Wed, 05 Mar 2008 14:22:19 +0100
Message-ID: <47CE9E8B.8050309@netfilter.org>
References: <47CAAD4E.3020508@trash.net> <47CE9E04.90308@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35847 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752629AbYCENRY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:17:24 -0500
In-Reply-To: <47CE9E04.90308@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> I mainly need conntrack event filtering capabilities by:
> 
> * protocol states, so that one can replicate TCP Established and 
> whatever state in the connection closure (or even the destroy event), I 
> don't need state transitions.
> * source address and destination, so that the administrator can 
> replicate traffic for certain parts of the networks, eg. 192.168.0.0/24

Well, also other descriptors such as the layer 4 protocol number, etc... 
I mean, similar descriptors to filter that are available in iptables.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
