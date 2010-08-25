From: Aijaz Baig <aijazbaig1@gmail.com>
Subject: Re: Fwd: help needed with EXPORT_SYMBOL
Date: Wed, 25 Aug 2010 14:57:58 +0530
Message-ID: <1282728478.17044.22.camel@aijazbaig1-desktop>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	 <1282540448.4080.86.camel@aijazbaig1-desktop>
	 <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
	 <1282569477.2605.1798.camel@laptop>
	 <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
	 <1282572346.2605.1856.camel@laptop>
	 <AANLkTimQDV74kcM_84QySMKmdf-XxFOhqp48cQdQNN4s@mail.gmail.com>
	 <AANLkTinRyoHcSmmHv9tZ36X4wxVVCKGLDwGiZUTPPn+z@mail.gmail.com>
	 <1282625054.4080.152.camel@aijazbaig1-desktop>
	 <AANLkTi=cj+qCFxeT5hq0-x-XqSUCbcqQRAwmQ9h+cOxy@mail.gmail.com>
	 <AANLkTim9nvJR0K6xJc2kHGCeoMzFLzSxR8Avx59jsEbf@mail.gmail.com>
Reply-To: aijazbaig1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: brgerst@gmail.com, peterz@infradead.org, jengelh@medozas.de,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50979 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0HYJ2N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:28:13 -0400
In-Reply-To: <AANLkTim9nvJR0K6xJc2kHGCeoMzFLzSxR8Avx59jsEbf@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone

I am trying to understand if its possible to add functions dynamically
to the kernel source based on the presence of certain modules in the
running kernel image.

I did try what brian suggested with the function pointer and yeah it
does work. But I could not understand what peter was trying to say about
modular users since I suppose he mentioned one module (B in this case)
using a function pointer defined in (or by) module A. In my case, since
it is the kernel that is gonna use the function, I need to make sure
that the module doesn't get unloaded while we are using the function.

By the way Jan I couldnt find bridge.c although there is an object file
called bridge.o within /net/bridge. Nonetheless, I did check
nf_nat_ftp.c as an example to see if something similar is being done
there too. What I did find out is that nf_nat_ftp_hook is rcu assigned
in nf_nat_ftp.c however this function pointer is being used with
nf_contrack_ftp.c (im talkin 2.6.27.45 here). In this case, it still is
module1 <- module2 and not kernel <- module. Could you please elaborate
a little how it affects the latter case. Or perhaps u were commenting on
the former case since peter brought that to our notice.

thanks again for your replies and keen to hear your input
Regards,
Aijaz Baig 

> 
> 
> ---------- Forwarded message ----------
> From: Brian Gerst <brgerst@gmail.com>
> Date: Tue, Aug 24, 2010 at 4:46 PM
> Subject: Re: help needed with EXPORT_SYMBOL
> To: aijazbaig1@gmail.com
> 
> 
> 
> On Tue, Aug 24, 2010 at 12:44 AM, Aijaz Baig <aijazbaig1@gmail.com>
> wrote:
> > Hello everyone,
> >
> > thanks for sending in the replies with so many options. I am still a
> > relative newbie so please do bear with me guys if I sound a bit
> naive at
> > times.
> >
> > I'll first start with brian's suggestion. He said:
> > "Use an exported function pointer in the main kernel as a hook that
> the
> > module sets when it is loaded.  Note, you must use module_get and
> > module_put around the call to the module to prevent it from
> unloading
> > while in use."
> >
> > I have never used such a technique and do not understand what you
> mean.
> > Could you please elaborate a little. Do you mean I should NF_HOOK
> within
> > the kernel code and then make the function that I would like to
> execute
> > as the hookfn? Well..if this is what u meant then wouldn't it also
> cause
> > all hooks at that particular position to be executed as well?
> >
> > And then peter and finally jan came up with, perhaps better
> suggestions
> > (i really cannot judge the quality of any of these suggestions..m
> too
> > much of a noob to do that). I got confused in the XY explanation by
> jan
> > since there both X and Y are modules it seems and I was talking
> about a
> > module exporting a certain symbol to be used by the kernel. Peter
> did
> > suggest notification chains. Is there a simple example that I can
> look
> > at? Will it allow the kernel to see symbols defined within the
> module?
> >
> > Lastly, will I be able to use kallsyms_lookup() to do what I can? I
> > notice that it replaced EXPORT_SYMTAB sometime back. So if yes I can
> use
> > it, does anyone know how to fill in the very first parameter of this
> > function which says address (of what exactly and how am I supposed
> to
> > know this address?)
> >
> > Keen to hear from you and once again, thank you for your inputs,
> 
> 
> You still haven't explained why you want to lookup a symbol in a
> module from the main kernel.  There is probably a better way of doing
> it.
> 
> --
> Brian Gerst
> 
> 


