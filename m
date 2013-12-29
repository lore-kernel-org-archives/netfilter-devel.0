From: Eric Leblond <eric@regit.org>
Subject: [RFC PATCHv3 finish reject support]
Date: Sun, 29 Dec 2013 12:28:12 +0100
Message-ID: <1388316494-1194-1-git-send-email-eric@regit.org>
References: <1388155892.6117.7.camel@ice-age2.regit.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:53596 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab3L2L2c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Dec 2013 06:28:32 -0500
In-Reply-To: <1388155892.6117.7.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here's a rework of previous patchset. No change on first patch if we
omit rebase on current code. Second patch now uses separate includes
for IPv6 and IPv4. It also fixes the dependency issue with IPv6 code
by adding a depends in Kconfig.

BR,
--
Eric Leblond
