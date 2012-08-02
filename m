From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] TARPIT: fix memory leak when tarpit_generic() fails
Date: Thu, 2 Aug 2012 17:48:20 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208021748121.10019@frira.zrqbmnf.qr>
References: <1343858862-32366-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:53298 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2HBPsW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:48:22 -0400
In-Reply-To: <1343858862-32366-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-08-02 00:07, Josh Hunt wrote:

>Currently tarpit_generic() just returns on failure, but this does
>not free nskb.

Processed.
