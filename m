From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/3] Add event type to NFCT plugin
Date: Mon, 17 Mar 2008 01:07:00 +0100
Message-ID: <12057124233723-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:44212 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753058AbYCQAHF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2008 20:07:05 -0400
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1Jb2sZ-00036H-Ba
	for netfilter-devel@vger.kernel.org; Mon, 17 Mar 2008 01:07:03 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

The following patchset contains a light configuration file improvement and a
work on NFCT.

NFCT default configuration was to compute internally all information relative
to a conntrack entry. With this setup the only logged message is the destroy
event. This patchset adds a configuration variable (event_mask) which is used
to defined the type of message ulogd listen to. It also modify the behaviour
of NFCT plugin to dump the event type (a ct.event key has been added). Finally
support for event type display has been added to the printflow filter.

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
