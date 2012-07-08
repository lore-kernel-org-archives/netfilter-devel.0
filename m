From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2 5/6] netfilter: tarpit: Add IPv6 support
Date: Sun, 8 Jul 2012 21:36:35 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207082125590.11837@frira.zrqbmnf.qr>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com> <1341771085-5771-6-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:57821 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2GHTgi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:36:38 -0400
In-Reply-To: <1341771085-5771-6-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-07-08 20:11, Josh Hunt wrote:

>This adds IPv6 support for the tarpit target. It performs the same
>functionality as the v4 version, but with IPv6 connections.

I have applied the rest so far; see the "tarpit6" branch of the git 
repository,

I have applied the rest so far, with minor modifications regarding 
style. See the "tarpit6" branch of the git repository.

This patch 5 does not compile for Linuxes >= v3.3 due to new arguments 
to ipv6_skip_exthdr and the removal of ipv6_addr_copy. Please send an 
additional patch on top to make it work with Linux 3.5(-rc). There will 
be no need to add #ifdefs for 3.3ish, because compat_xtables* already 
takes care of that mostly.


