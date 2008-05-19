From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/9] Misc work over Pablo's patchset
Date: Tue, 20 May 2008 00:31:26 +0200
Message-ID: <1211236295-30207-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38763 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752835AbYESWad (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:33 -0400
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1JyDtI-0007w5-1k
	for netfilter-devel@vger.kernel.org; Tue, 20 May 2008 00:31:36 +0200
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset contains some modifications over latest Pablo's patchset as
well as fix related to the last git migration or PGSQL improvement. This
last part is a rework of my latest patchset.

I've tested Pablo's patchset and it seems to behave well (NFCT is working,
NFLOG handling of stress is far better when using socket related options).
The only problem was related to a crash in the module IP2STR due to the
introduction of ui128 type.

This is fixed by the patch:
 * Fix crash IP2BIN and IP2STR due to ui128 type introduction.

I've also done a slight modification of overrun related messages to add a new
line:
 * Add a lacking newline in buffer overrun messages.

The main modification is brought by the patch:
 * Only use overrun handling if local hash is used.
This modify the behaviour of NFCT overrrun handling to only dump the conntrack
in case of overrun if the local hash is used. The goal of this modification is
to avoid to flood output modules which are not able to interpret well this type
of dump.

Next patches aim at adding timestamp to some messages. NFCT without local hash
did not fill the timestamp it was able to fill. On NFLOG side, INPUT and OUTPUT
packet were logged without timestamp. The patch make ulogd compute the
timestamp:
 * Set timestamp in NFLOG for INPUT and OUTPUT.
 * Fill the maximum of timestamp.

The next patches improve PGSQL support:
 * Sync PGSQL schema with NFCT.
 * Add INSERT_OR_REPLACE_CT pgsql function.
It is now possible to use PGSQL for NFCT in non hash mode. This can be used to
have a SQL duplication of the connection tracking table.

Switching to git seems to have cause the lost of some files. The following
patch recover them:
 * Add some missing files to git repository.

Last patch brings the configuration file in sync with latest change:
 * Update config file to be in sync with latest modifications.

Here's the global stats:
 Rules.make.in                     |   43 +++++++++++++++
 doc/pgsql-ulogd2.sql              |   89 +++++++++++++++++++++++++-----
 filter/ulogd_filter_IP2BIN.c      |    2 +-
 filter/ulogd_filter_IP2STR.c      |    2 +-
 input/flow/ulogd_inpflow_NFCT.c   |  108 ++++++++++++++++++++++++------------
 input/packet/ulogd_inppkt_NFLOG.c |   19 ++++---
 ulogd.8                           |   64 ++++++++++++++++++++++
 ulogd.conf.in                     |   36 ++++++++++++
 8 files changed, 302 insertions(+), 61 deletions(-)

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
