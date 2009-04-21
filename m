From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Build breakage in 1.4.3
Date: Wed, 22 Apr 2009 00:46:46 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904220046170.20050@fbirervta.pbzchgretzou.qr>
References: <5ee96a840904211350ofc00f91r98491da19638edf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Matthew L. Creech" <mlcreech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52615 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZDUWqs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:46:48 -0400
In-Reply-To: <5ee96a840904211350ofc00f91r98491da19638edf0@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-04-21 22:50, Matthew L. Creech wrote:

>When trying to cross-compile iptables 1.4.3 or later, I get:
>
>make[5]: *** No rule to make target `extensions/libext4.a', needed by
>`iptables'.  Stop.
>
>The problem seems to be due to this change:
>
>https://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commit;h=f92d6b05abd217c3e152caa2c494a138ccd5096e
>
>If I revert that, the build completes, but (just guessing from the
>commit msg) that doesn't seem like an appropriate general solution.

Which cross combination is this please?
