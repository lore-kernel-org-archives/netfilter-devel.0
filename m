From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Fwd: help needed with EXPORT_SYMBOL
Date: Wed, 25 Aug 2010 08:37:05 -0700
Message-ID: <20100825083705.35a6195f.randy.dunlap@oracle.com>
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: brgerst@gmail.com, peterz@infradead.org, jengelh@medozas.de,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: aijazbaig1@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:37378 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0HYPiC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:38:02 -0400
In-Reply-To: <1282728478.17044.22.camel@aijazbaig1-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 25 Aug 2010 14:57:58 +0530 Aijaz Baig wrote:

> By the way Jan I couldnt find bridge.c although there is an object file
> called bridge.o within /net/bridge. Nonetheless, I did check

See net/bridge/Makefile:

obj-$(CONFIG_BRIDGE) += bridge.o

bridge-y	:= br.o br_device.o br_fdb.o br_forward.o br_if.o br_input.o \
			br_ioctl.o br_notify.o br_stp.o br_stp_bpdu.o \
			br_stp_if.o br_stp_timer.o br_netlink.o

and see Documentation/kbuild/makefiles.txt.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
