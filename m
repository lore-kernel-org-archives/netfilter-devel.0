From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in
 net/ipv6/netfilter/ip6_tables.c
Date: Tue, 23 Mar 2010 04:04:59 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003230346010.12017@obet.zrqbmnf.qr>
References: <20100320143240.GB2942@localhost.localdomain>  <4BA7A3CF.8070503@trash.net>  <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>  <7b6bb4a51003221929i16673523nd5f558ccbaace397@mail.gmail.com>
 <628d1651003221937q58ff39fel467636ab55531128@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Xiaotian Feng <xtfeng@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: wzt wzt <wzt.wzt@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58508 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab0CWDFA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:05:00 -0400
In-Reply-To: <628d1651003221937q58ff39fel467636ab55531128@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-23 03:37, wzt wzt wrote:
>> And, for the addition overflow, can it be caught by
>>
>> "if (*len != sizeof(struct ipt_get_entries) + get.size)"  ???
>
>sizeof(struct ipt_get_entries) + get.size can be overflow as *len,
>get.size is control by user space with copy_from_user().

The != should catch it.

For 64-bit environments:
* + invoked with size_t, unsigned int
  => right side promoted to size_t, result type is size_t
* != invoked with int and size_t
  => left-side promoted to ssize_t (probably; but something as large as size_t)
* get.size is 32-bit bounded, as is *len,
  so no overflow to worry about at all unless you make
  sizeof(X) hilariously big close to 2^64 which is rather unlikely.

For 32-bit environments:
* Let *len be a number of choice (e.g. 36)
* Find a sizeof(X)+get.size that equals 36 mod 2^32.
* Since sizeof(X) is const, get.size must be 0 mod 2^32.
* So get.size must be a multiple of 2^32 to fool the system.
* Since get.size itself is only a 32-bit quantity, you cannot
  represent any value larger than 4294967295.


What Was What Was Wanted.
