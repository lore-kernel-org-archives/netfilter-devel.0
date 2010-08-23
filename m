From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: help needed with EXPORT_SYMBOL
Date: Mon, 23 Aug 2010 16:05:46 +0200
Message-ID: <1282572346.2605.1856.camel@laptop>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	 <1282540448.4080.86.camel@aijazbaig1-desktop>
	 <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
	 <1282569477.2605.1798.camel@laptop>
	 <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: aijazbaig1@gmail.com, netfilter-devel@vger.kernel.org,
	jengelh@medozas.de, linux-kernel@vger.kernel.org
To: Brian Gerst <brgerst@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0HWOFs convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:05:48 -0400
In-Reply-To: <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-08-23 at 09:44 -0400, Brian Gerst wrote:
> The assumption was that there was a single module using that hook.

Not really a future-proof design, is it?
