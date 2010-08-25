From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Fwd: help needed with EXPORT_SYMBOL
Date: Wed, 25 Aug 2010 12:23:35 +0200
Message-ID: <1282731815.2605.3473.camel@laptop>
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
	 <1282728478.17044.22.camel@aijazbaig1-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: brgerst@gmail.com, jengelh@medozas.de,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: aijazbaig1@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0HYKXi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:23:38 -0400
In-Reply-To: <1282728478.17044.22.camel@aijazbaig1-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2010-08-25 at 14:57 +0530, Aijaz Baig wrote:

> I am trying to understand if its possible to add functions dynamically
> to the kernel source based on the presence of certain modules in the
> running kernel image.
> 
> I did try what brian suggested with the function pointer and yeah it
> does work. But I could not understand what peter was trying to say about
> modular users since I suppose he mentioned one module (B in this case)
> using a function pointer defined in (or by) module A. In my case, since
> it is the kernel that is gonna use the function, I need to make sure
> that the module doesn't get unloaded while we are using the function.

Right, so there's two problems there:

 - the exposed function pointer
 - unload serialization

The problem with the exposed function pointer is that two competing
modules can set the function pointer:

extern void (*ptr)(void);

static void (*old_ptr)(void);

void func(void)
{
  /* do something */
}

module_init()
{
  old_ptr = ptr;
  ptr = func;
}

module_exit()
{
  ptr = old_ptr;
  synchronize_stuff();
}

Now suppose two modules A and B both have that template, then load
module A, at that time ptr == A::func, A::old_ptr = NULL, right?

Then load B, then ptr == B:func, B::old_ptr = A::func.

then unload A, then ptr == NULL; /* hey where's B gone? */

Suppose module_exit() had read:

module_exit()
{
  if (ptr == func)
    ptr = old_ptr;
}

Then after A got unloaded, you'd have: ptr = B::func, B::old_ptr ==
A:func, and the world goes *bang* when you unload B.

If you'd have exposed the thing like:

static void (*callback)(void);

int set_foo_callback(void (*func)(void))
{
  if (callback && func)
    return -EBUSY;

  callback = func;
  synchronize_world();
  return 0;
}
EXPORT_SYMBOL_GPL(set_foo_callback);

Then there'd be no confusion, as loading B while A was already loaded
would fail since set_foo_callback() would fail with -EBUSY.


Now the synchronization issue, above represented by synchronize_world();
that will have to do something that ensures all current users of the ptr
have gone, taking a reference on the module will likely result in an
pinned module, since what will drop the ref again?

Module unload does a fairly heavy stop-machine thing, which might be
sufficient for some, but a sensible solution really depends on the
problem domain, RCU could be used in various ways.
