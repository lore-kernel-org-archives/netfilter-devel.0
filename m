From: Luca Tettamanti <kronos.it@gmail.com>
Subject: [BUG?] ip6tables: 32bit userspace doesn't work with 64bit kernel
Date: Sat, 8 Dec 2007 23:37:37 +0100
Message-ID: <20071208223737.GA8885@dreamland.darkstar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:44245 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbXLHWhk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:37:40 -0500
Received: by nf-out-0910.google.com with SMTP id g13so639359nfb
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Dec 2007 14:37:38 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
I just found out that 32bit (x86) ip6tables does not work with a 64bit
kernel. I'm currenly using 2.6.24-rc4-g94545bad, but the structures
involved haven't been touched recently.

Before you read on: I see that IPv6 code is missing compat* stuff, so is
this configuration supported?

A simple "ip6tables -L" fails with:
ip6tables v1.3.8: can't initialize ip6tables table `filter': Bad file
descriptor

kernel says:
get_entries: 892 != 896 (this is do_ip6t_get_ctl)

The problem is that GCC changes the layout of a couple of structures
when compiling 64bit code.
Compiler version - in case it started doing this recently - is:
gcc (GCC) 4.2.2 (Debian 4.2.2-1)

This is what userspace (32bit) is using:

sizeof(struct ip6t_entry) = 164
        ipv6            0
        nfcache         136
        target_offset   140
        next_offset     142
        comefrom        144
        counters        148
        elems           164
sizeof(struct ip6t_get_entries) = 36
        name            0
        size            32
        entrytable      36
sizeof(struct xt_counters) = 16

And this is what the kernel (64bit) expects:

sizeof(struct ip6t_entry) = 168
        ipv6            0
        nfcache         136
        target_offset   140
        next_offset     142
        comefrom        144
        counters        152 <--- ouch
        elems           168
sizeof(struct ip6t_get_entries) = 40
        name            0
        size            32
        entrytable      40
sizeof(struct xt_counters) = 16

It seems that the compiler - in 64 bit mode - goes for 8 bytes alignment
for "counters" (which contains a couple of int64); I guess that
ip6t_get_entries is changed to keep the very same field (in entrytable)
aligned.

Luca
-- 
The trouble with computers is that they do what you tell them, 
not what you want.
