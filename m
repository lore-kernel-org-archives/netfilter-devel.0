From: Chris Boot <bootc@bootc.net>
Subject: [PATCH 0/2] Introductions, some tweaks to ulogd
Date: Sat, 11 May 2013 18:01:51 +0100
Message-ID: <1368291713-40132-1-git-send-email-bootc@bootc.net>
Cc: Chris Boot <bootc@bootc.net>, Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:46406 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3EKRKm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 13:10:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi folks,

I am working on packaging ulogd-2.x for Debian, and currently have an initial
set of packages uploaded and waiting for ftpmaster review in the NEW queue.
I'd like to say hello to all folks involved with ulogd, and thanks for all the
hard work getting it to where it is. Hopefully we can work together and make
ulogd-2.x a first class citizen in Debian.

I intend to be a fully cooperative downstream maintainer, and to prove my
intentions here are a couple of patches that I've been working on for the next
upload of ulogd2.

The first patch simply fixes the deamon being able to nice() itself when run
with the --uid argument. Currently the code runs nice() after setuid(); this
fails to increase its priority as it is no longer root. The patch simply moves
the code around a little to fix this.

The second patch adds a --pidfile option to ulogd, which enables it to write a
PID file to somewhere like /var/run (or just /run). This is very useful within
init scripts to make sure you're sending signals to the correct process.

Cheers,
Chris

Chris Boot (2):
  ulogd: Perform nice() before giving up root
  ulogd: Implement PID file writing

 src/ulogd.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 8 deletions(-)

-- 
1.7.10.4

