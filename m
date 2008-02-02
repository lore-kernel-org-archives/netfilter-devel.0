From: heitzenberger@astaro.com
Subject: [ULOGD 00/15] ulogd V2 improvements, round 2
Date: Sat, 02 Feb 2008 21:48:26 +0100
Message-ID: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-47.dex002.intermedia.net ([64.78.21.143]:21876 "EHLO
	dhost002-47.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764479AbYBBUvX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

this is a follow-up to my previous ulogd V2 improvements patchset
send to you as an RFC.

The changes to the previous set of patches are rather small, namely
the code of the NFCT plugin contains two small changes after feedback
from Pablo Neira.

Because all those changes were strictly chronological, with some
of the changes confusingly reverted later, I decided to stuff the
NFCT-related changes into one, as well as for the SQLITE3 related
ones.  Therefore the number of patches reduces from 30 to 15.

After the feedback I've got I'll suggest to apply all the patches
without the last NFCT one.  It is applied just as an RFC.

My intention is to turn the output keys of the NFCT plugin compatible
to the former one, and also add a configuration option to control
whether to propagate one dataset per flow or two (as it was before).

Because the NFCT-related changes depend on a patchlet to
libnetfilter-conntrack which might actually not be applied, I'll
suggest to convert the code base to libnl sooner.  Any objections?

Any feedback welcome.

 /holger

