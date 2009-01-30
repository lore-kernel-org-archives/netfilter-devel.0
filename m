From: Eric Leblond <eric@inl.fr>
Subject: Add real default to NFLOG qthreshold
Date: Fri, 30 Jan 2009 23:31:45 +0100
Message-ID: <1233354708-22009-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:51951 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753940AbZA3Wbv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:31:51 -0500
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1LT1ts-000666-TJ
	for netfilter-devel@vger.kernel.org; Fri, 30 Jan 2009 23:31:48 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The goal of this patchset is to fix some issues with NFLOG. This target has a
qthreshold value that can be set from iptables or from libnetfilter_log. If the
qthreshold is set from libnetfilter_log and if the rule does not set the value,
NFLOG should use the instance default. This is not the case, because iptables
set the qthreshold to 1 by default and this is used as a user-defined value by
kernel. This patchset fixes the issue by using the qthreshold as default for
iptables:
 - netfilter 1/2: if set per-rule qthreshold overrides per-instance
 - iptables: xt_NFLOG: Set default NFLOG qthreshold to 0

This patchset also fixes an issue with definition of timeout in the logging
queue. It fixes a computation error and change the unit to millisecond which
is a more convenient as the targeted 1/100 sec:
 - netfilter 2/2: fix nflog timeout handling

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
