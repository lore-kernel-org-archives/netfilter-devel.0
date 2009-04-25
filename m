From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Prombles compiling xtables-addons 1.14 with kernel 2.6.29.1
Date: Sat, 25 Apr 2009 19:45:30 +0200
Message-ID: <17e3a8f80904251045i106aba94g795a230b49d67223@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57830 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZDYRpc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Apr 2009 13:45:32 -0400
Received: by fxm2 with SMTP id 2so1600319fxm.37
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Apr 2009 10:45:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I recently had to upgrade my kernel to 2.6.29.1 and I am no longer
able to compile xtables-addons. I have run "make clean" and rerun
configure, but when I try to compile I get a message saying that
"register_target", "_targets" and so on (all the xt_...) functions are
undefined. Does anyone have any hints or suggestions?

I have recompiled iptables 1.4.3.2 and my .config xtables is compiled
into the kernel as a module.

Thanks in advance,
Kristian
