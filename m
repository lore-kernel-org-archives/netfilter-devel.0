From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 0/2] routing via nfmark in OUTPUT NFQUEUE
Date: Mon, 24 Nov 2008 21:46:45 +0100
Message-ID: <1227559607-3077-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39498 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753047AbYKXUqu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:46:50 -0500
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1L4iKV-0000od-6c
	for netfilter-devel@vger.kernel.org; Mon, 24 Nov 2008 21:46:47 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This small patchset is a resend of a work by Laurent Licour. It
adds a rerouting possibility if the mark has been changed in OUTPUT
via NFQUEUE. First patch is IPv4 version from Laurent Licour, second
patch is a port to IPv6 I've done.

BR,
--
Eric Leblond <eric@inl.fr>
NuFW, Now User Filtering Works : http://www.nufw.org
