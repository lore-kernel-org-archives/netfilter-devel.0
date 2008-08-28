From: fender <frozenspot@gmail.com>
Subject: [update] port knocking match extension
Date: Thu, 28 Aug 2008 01:28:01 -0300
Message-ID: <7e36c7130808272128l22aa701by97169ca79312dc82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, lucholaf@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:33430 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYH1E2E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Aug 2008 00:28:04 -0400
Received: by yw-out-2324.google.com with SMTP id 9so15304ywe.1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2008 21:28:02 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi people,

We've applied some patches to add support for kernel 2.6.26 and iptables 1.4.x.

You can download the tarball "pknock-0.5.tar.gz" from the web site and
compile the match extension and the iptables extension, but without
the need of recompiling the kernel.

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
