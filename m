From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 0/2] work on restoration
Date: Sun,  9 Jun 2013 01:08:45 +0200
Message-ID: <1370732927-23322-1-git-send-email-eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56759 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3FHXI6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 19:08:58 -0400
Received: from bayen.regit.org ([81.57.69.189] helo=ice-age.regit.org)
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1UlSFi-0003CT-LC
	for netfilter-devel@vger.kernel.org; Sun, 09 Jun 2013 01:08:55 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This small patchset is an effort to make restoration possible.
The commands:
	nft list table filter >rule.dump
	nft -f rule.dump
should backup and restore the ruleset.

This patchset fixes restoration for some ruleset. Ruleset
using limit are currently not supported. I've created a ticket
on bugzilla (http://bugzilla.netfilter.org/show_bug.cgi?id=827).

BR,
--
Eric
