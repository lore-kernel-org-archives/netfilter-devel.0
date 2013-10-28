From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/2] build: resolve build errors in dependent programs
Date: Mon, 28 Oct 2013 13:27:22 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1310281314430.5620@nerf07.vanv.qr>
References: <1382279356-5050-1-git-send-email-jengelh@inai.de> <1382279356-5050-3-git-send-email-jengelh@inai.de> <20131027210138.GA11945@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34041 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab3J1M1Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:27:25 -0400
In-Reply-To: <20131027210138.GA11945@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2013-10-27 22:01, Pablo Neira Ayuso wrote:
>On Sun, Oct 20, 2013 at 04:29:16PM +0200, Jan Engelhardt wrote:
>> 
>> 	chain.h:44:71: warning: "struct nlmsghdr" declared inside
>> 	parameter list [enabled by default]
>> 	chain.h:60:35: error: unknown type name "size_t"
>
>This is fixing two different issues in one single patch.
>I have applied a patch to add struct nlmsghdr without definition.

Well, there's still size_t left.

>Regarding the c++ changes, we already discussed this in libmnl's
>patch:
>
>5b8a0c7 include: don't force compiler to enter C++11 mode
>
>this change doesn't seem to be required by g++ at all.

Not required by g++, but wanted by the standard. Also note that
in my current submission, I expressly specified

#if ... __cplusplus >= 2011UL.

which is how to tackle this. The remaining patches will be posted
by git-s-e shortly.
