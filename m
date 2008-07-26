From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 0/2] MAC2STR rework
Date: Sat, 26 Jul 2008 17:43:46 +0200
Message-ID: <1217087028-1136-1-git-send-email-eric@inl.fr>
References: <20080724171600.GA23670@khasse.inl.fr>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:41933 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752244AbYGZPnu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:43:50 -0400
In-Reply-To: <20080724171600.GA23670@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This patchset contains a merge of my born-dead plugin RAWMAC with MAC2STR and
a renaming of MAC2STR to HWHDR.

Patch 4/4 of my previous patchset (DB changes) remains valid relatively to
this change.

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
