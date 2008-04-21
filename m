From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/5] Resent work related to 'label' and misc fixes
Date: Mon, 21 Apr 2008 22:43:42 +0200
Message-ID: <12088106273628-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:40010 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154AbYDUUnt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:43:49 -0400
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1Jo2rb-0004D2-6f
	for netfilter-devel@vger.kernel.org; Mon, 21 Apr 2008 22:43:47 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset contains work related to the label option:
 * 0001-Add-label-option-to-ULOG-input-plugin.patch
 * 0004-Add-label-option-to-NFLOG-input-plugin.patch
 * 0005-Update-default-configuration-to-fit-last-changes.patch

It also adds hook support to ULOG:
 * 0002-Add-hook-output-to-ULOG-input-module.patch
and fixes a macro in NFLOG:
 * 0003-Fix-a-bug-in-definition-of-seq_global_ce-macro.patch

Patches providing 'label' support to databases will be sent by Pierre
Chifflier in an other patchset.

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
