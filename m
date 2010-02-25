From: Patrick McHardy <kaber@trash.net>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 11:23:22 +0100
Message-ID: <4B864F9A.90207@trash.net>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netfilter@vger.kernel.org
To: Jiri Pirko <jpirko@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63474 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983Ab0BYKXY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:23:24 -0500
In-Reply-To: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jiri Pirko wrote:
> Hi all.
> 
> I want to ask if there is any particular reason for ipt_CLUSTERIP to support
> only address length of 6 (ETH_ALEN)? It seems to me reasonable for this to work
> even with another types of network hw with different addr_len.

None that I'm aware of, but the length is also used in the ABI,
so you presently can't supply larger addresses.
