From: fender <frozenspot@gmail.com>
Subject: [update] ipt_pknock match extension
Date: Thu, 17 Jan 2008 14:01:05 +0100
Message-ID: <7e36c7130801170501v450fda81xcec002e780a2087e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, lucholaf@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:31511 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYAQNBG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:01:06 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1067729wah.23
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jan 2008 05:01:06 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi people,

We've applied some patches to add support for kernel 2.6.23 and fix
some minor bugs.
Thanks to Piotr Gasidlo for the patch.

You can download it doing "./runme --download" and then recompiling
the kernel, or you can download the tarball "pknock-0.4.tar.gz" from
the web site and compile the match extension and the iptables
extension, but without the need of recompiling the kernel.

Any feedback or suggestion will be welcome.

Regards,

(*) The ipt_pknock match module implements Port Knocking and SPA
(Simple Packet Authentication) as a netfilter match extension.

(*) More information at http://portknocko.berlios.de/

-- 
Federico

/*
 *  J. Federico Hernandez Scarso (fender) {frozenspot at gmail dot com}
 *  GPG PubKey: wwwkeys.eu.pgp.net key 6AE78BF2
 *  FP: 26AB 7A1B C2C4 70F8 0E7D  C3F4 9736 5CE2 6AE7 8BF2
 */
