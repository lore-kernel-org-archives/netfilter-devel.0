From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 0/2] Misc cleaning
Date: Wed,  9 Jul 2008 22:56:43 +0200
Message-ID: <1215637005-3102-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:44148 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756947AbYGIU4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:56:47 -0400
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1KGgiT-0000pH-Ac
	for netfilter-devel@vger.kernel.org; Wed, 09 Jul 2008 22:56:45 +0200
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This small patchset features some cleaning. The main patch is relative
to a wrong computation of a buffer size in the databases plugins.

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
