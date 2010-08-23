From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: help needed with EXPORT_SYMBOL
Date: Mon, 23 Aug 2010 15:17:57 +0200
Message-ID: <1282569477.2605.1798.camel@laptop>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	 <1282540448.4080.86.camel@aijazbaig1-desktop>
	 <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: aijazbaig1@gmail.com, netfilter-devel@vger.kernel.org,
	jengelh@medozas.de, linux-kernel@vger.kernel.org
To: Brian Gerst <brgerst@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0HWNSC convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:18:02 -0400
In-Reply-To: <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-08-23 at 07:48 -0400, Brian Gerst wrote:
> 
> Use an exported function pointer in the main kernel as a hook that the
> module sets when it is loaded.  Note, you must use module_get and
> module_put around the call to the module to prevent it from unloading
> while in use. 

Please don't do any such thing, its impossible to use correctly.

Suppose there are two modular users, A and B.

Both have something like:

extern void (*fptr)(void);

static void (*old_fptr)(void);

static void func(void)
{
	/* foo */
	if (old_fptr)
		old_fptr();
}

module_init()
{
	old_fptr = fptr;
	fptr = A_func;
}

Then you load A, load B and unload A, then guess what happens?
