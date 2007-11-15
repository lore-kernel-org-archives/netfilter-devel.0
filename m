From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH - Fix for --random option in DNAT and REDIRECT
Date: Thu, 15 Nov 2007 13:59:50 +0100
Message-ID: <473C42C6.8090006@trash.net>
References: <473B63ED.7020307@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
To: Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43966 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbXKONAR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:00:17 -0500
In-Reply-To: <473B63ED.7020307@shorewall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Tom Eastep wrote:
> The --random option produces "Unknown arg `--random'" errors with both the
> DNAT and REDIRECT targets. Corrected by the attached patch.

The REDIRECT part didn't apply cleanly because of changes in the
tree. Please always base your patches on the latest version.

Anyway, I've fixed it up and applied it, thanks Tom.
