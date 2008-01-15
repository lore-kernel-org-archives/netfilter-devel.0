From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] add netfilter gcc printf format checking
Date: Tue, 15 Jan 2008 08:07:54 +0100
Message-ID: <478C5BCA.8070900@trash.net>
References: <200801061445.53098.deller@gmx.de> <200801062116.38955.deller@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63233 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYAOHIB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:08:01 -0500
In-Reply-To: <200801062116.38955.deller@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Helge Deller wrote:
> updated patch below
> =================
> 
> [PATCH] add netfilter gcc printf format checking

This does not apply to the current tree because the logging
functions have been move to a seperate header. Could you
rediff against

git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.25.git

please and resend? Ideally wait until my last batch of patches
hits that tree so you don't run into new conflicts.

