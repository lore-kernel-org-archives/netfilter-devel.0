From: Florian Westphal <fw@strlen.de>
Subject: iptables: add NFQUEUE balancing support
Date: Sun, 21 Jun 2009 01:42:29 +0200
Message-ID: <1245541351-18513-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34439 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbZFTXge (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:36:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

here is the re-send of the userspace nfqueue changes.
Changes since v1:
- re-arranged manpage
- consolidated v1 target into single NFQUEUE_UNSPEC structure
  (as suggested by Jan).
- use same options for v0 and v1; this will result in a more
  verbose error when --queue-balance is used with a "NFQUEUE v0 only"
  kernel (v1 patch would just give a "unkown option" error).

Also available via git, but to ease review I'll send the patches
as followup to this mail.
Jozsef just sent a few patches that will most likely cause conflicts
with this patchset. I can re-base my patches on top of iptables.git
if his patches are applied first, just let me know.

The following changes since commit f9bf812aed50949db584cdf93752193c802fefcb:
  Patrick McHardy (1):
        Bump version

are available in the git repository at:

  git://git.breakpoint.cc/fw/iptables.git nfq_balance

Florian Westphal (2):
      libxt_NFQUEUE: use NFPROTO_UNSPEC
      libxt_NFQUEUE: add new v1 version with queue-balance option

 extensions/libxt_NFQUEUE.c           |  119 ++++++++++++++++++++++++++++++----
 extensions/libxt_NFQUEUE.man         |   18 ++++--
 include/linux/netfilter/xt_NFQUEUE.h |    5 ++
 3 files changed, 122 insertions(+), 20 deletions(-)

