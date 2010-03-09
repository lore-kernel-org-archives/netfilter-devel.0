From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [RELEASE] bridge-netfilter patch version 12 for 2.4.37.9
Date: Tue, 09 Mar 2010 12:13:26 +0100
Message-ID: <4B962D56.4000608@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dong Wei <dwei.zh@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:38934 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0CILN3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:13:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

The bridge-netfilter backport to the 2.4 kernel seems to still be used
by some organizations. Therefore I've released an updated version of the
patch containing two important bugfixes:
- fix security bug where any program can update the ebtables rules.
Backported patch, original patch from Florian Westphal.
- fix possible kernel panic when receiving special fragments. Backported
by Dong Wei, original patch by Patrick McHardy.

See http://ebtables.sourceforge.net/downloads/latest.html

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
