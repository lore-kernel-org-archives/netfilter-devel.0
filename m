From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Prombles compiling xtables-addons 1.14 with kernel 2.6.29.1
Date: Tue, 28 Apr 2009 09:59:48 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904280959310.21875@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80904251045i106aba94g795a230b49d67223@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36928 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760832AbZD1H7t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:59:49 -0400
In-Reply-To: <17e3a8f80904251045i106aba94g795a230b49d67223@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-04-25 19:45, Kristian Evensen wrote:

>Hello,
>
>I recently had to upgrade my kernel to 2.6.29.1 and I am no longer
>able to compile xtables-addons. I have run "make clean" and rerun
>configure, but when I try to compile I get a message saying that
>"register_target", "_targets" and so on (all the xt_...) functions are
>undefined. Does anyone have any hints or suggestions?
>
>I have recompiled iptables 1.4.3.2 and my .config xtables is compiled
>into the kernel as a module.

Posting the error message might get us somewhere.

