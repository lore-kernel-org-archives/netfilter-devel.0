From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 0/3] iptables-edit: tool to apply iptables rules to
 iptables-save'ed statefiles
Date: Wed, 7 Nov 2007 11:49:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711071148530.1982@fbirervta.pbzchgretzou.qr>
References: <472E6039.7060801@endian.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43190 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbXKGKuA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 05:50:00 -0500
In-Reply-To: <472E6039.7060801@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 5 2007 01:13, Peter Warasin wrote:
>
>Most firewall scripts (for example fwbuilder, shorewall, firehole,
>etc..) work always this way:
>- They flush and remove all iptables chains
>- Apply the iptables rules successively by:
>  o Compile a shell script with an iptables rule per line
>  o Calculating the iptables rules from a configuration file on the fly.

fwbuilder uses (can use) iptables-save.
