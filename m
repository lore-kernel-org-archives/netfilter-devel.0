From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] ctnetlink: add netns support
Date: Wed, 13 Jan 2010 13:58:02 +0100
Message-ID: <4B4DC35A.9000600@trash.net>
References: <20100113122637.GB5790@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42319 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0AMM6I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:58:08 -0500
In-Reply-To: <20100113122637.GB5790@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Allow conntrack program to operate correctly in netns.
> Note: passing events is not done in this patch.

Why not? It seems like a small change and without this the netns
support will still be incomplete.

