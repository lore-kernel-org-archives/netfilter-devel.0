From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: bump library versioning
Date: Wed, 16 Sep 2015 22:40:05 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1509162239440.7375@nerf40.vanv.qr>
References: <1442423567-12120-1-git-send-email-jengelh@inai.de> <20150916172836.GA29575@salvia> <20150916180048.GA4886@salvia> <20150916182251.GA3346@salvia> <alpine.LSU.2.20.1509162031310.13589@nerf40.vanv.qr> <20150916184939.GA14450@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:58711 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbbIPUkH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 16:40:07 -0400
In-Reply-To: <20150916184939.GA14450@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2015-09-16 20:49, Pablo Neira Ayuso wrote:
>
>I'm attaching your original patch, but I also included the LIBVERSION
>update into it.

A "local: *" needs to be readded in the .map file. Looks good 
otherwise.
