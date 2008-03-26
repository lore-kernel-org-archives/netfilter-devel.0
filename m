From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/6] Making NFCT plugin IPv6 compliant
Date: Wed, 26 Mar 2008 23:49:05 +0100
Message-ID: <12065717514081-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36532 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753850AbYCZWtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:49:13 -0400
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1JeeQh-00030z-JD
	for netfilter-devel@vger.kernel.org; Wed, 26 Mar 2008 23:49:11 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset contains several modifications which were necessary to make
the NFCT plugin IPv6 compliant.

Some code factorization has been made to avoid duplicating code:
- Make arp related key optionnal.
- Use IP2STR keys in PRINTFLOW module.
Last patch suppress IP to string translation in the PRINTFLOW module but
let IP2STR to do the work.

Some fixes have been made on existing code:
- Fix display of IPv6 address.
- Fix typo in error message.
- Fix display of DESTROY event.

And finally, NFCT plugin has been ported to the new API.
- Port of NFCT plugin to new libnetfilter_conntrack API.

I will soon send a other patchset with SQL schema modification and an upgrade
of the example configuration file.

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
