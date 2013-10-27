From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] build: resolve build errors in dependent programs
Date: Sun, 27 Oct 2013 22:01:38 +0100
Message-ID: <20131027210138.GA11945@localhost>
References: <1382279356-5050-1-git-send-email-jengelh@inai.de>
 <1382279356-5050-3-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34299 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab3J0VBn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:01:43 -0400
Content-Disposition: inline
In-Reply-To: <1382279356-5050-3-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 20, 2013 at 04:29:16PM +0200, Jan Engelhardt wrote:
> The headers do not compile standalone, which also causes nftables to
> fail to build for the same reason. In addition, <stdbool.h> is not
> needed for C++, and C++ should use contemporary headers if available,
> which is hereby done.
> 
> 	chain.h:44:71: warning: "struct nlmsghdr" declared inside
> 	parameter list [enabled by default]
> 	chain.h:60:35: error: unknown type name "size_t"
> 	expr.h:40:39: error: unknown type name "size_t"
> 	rule.h:43:64: warning: "struct nlmsghdr" declared inside
> 	parameter list [enabled by default]
> 	rule.h:59:34: error: unknown type name "size_t"
> 	ruleset.h:20:1: error: unknown type name "bool"
> 	ruleset.h:20:59: error: unknown type name "uint16_t"
> 	ruleset.h:39:37: error: unknown type name "size_t"
> 	set.h:38:33: error: unknown type name "size_t"
> 	table.h:32:71: warning: "struct nlmsghdr" declared inside
> 	parameter list [enabled by default]
> 	table.h:48:35: error: unknown type name "size_t"

This is fixing two different issues in one single patch.

I have applied a patch to add struct nlmsghdr without definition.

Regarding the c++ changes, we already discussed this in libmnl's
patch:

5b8a0c7 include: don't force compiler to enter C++11 mode

this change doesn't seem to be required by g++ at all.
