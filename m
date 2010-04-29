From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: conntrack h323 reassembly
Date: Thu, 29 Apr 2010 11:56:18 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004291154450.23971@obet.zrqbmnf.qr>
References: <20100428165541.174eb58e@nehalam>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53511 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233Ab0D3RAp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:00:45 -0400
In-Reply-To: <20100428165541.174eb58e@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-04-29 01:55, Stephen Hemminger wrote:

>It seems that h323 conntrack module can't handle TCP fragments.
>Is this a problem for other modules, or is it unique to H323?
>
>More detail:
>  https://bugzilla.vyatta.com/show_bug.cgi?id=5127

Fragments should not normally happen, as nf_conntrack loads 
nf_defrag.
