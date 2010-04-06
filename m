From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables pull: osf and misc
Date: Tue, 6 Apr 2010 20:21:11 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004062020210.31132@obet.zrqbmnf.qr>
References: <1270551164-2945-1-git-send-email-jengelh@medozas.de> <4BBB421A.3060703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54267 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab0DFSVO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:21:14 -0400
In-Reply-To: <4BBB421A.3060703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-04-06 16:15, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> The following changes since commit 21d1283750d9c4df7ca80165d2b9dc0b9bd214eb:
>>   Jan Engelhardt (1):
>>         iptables: correctly check for too-long chain/target/match names
>> 
>> are available in the git repository at:
>> 
>>   git://dev.medozas.de/iptables master
>> 
>> Jan Engelhardt (5):
>>       doc: libxt_MARK: no longer restricted to mangle table
>>       doc: remove claim that TCPMSS is limited to mangle
>>       libxt_recent: add a missing space in output
>>       doc: add manpage for libxt_osf
>>       libxt_osf: import nfnl_osf program
>
>This introduces a new dependency on libnfnetlink. I'd prefer if it would
>only build the osf utils when the library is present.

Updated. Though I bet a pint that there is at least one distribution
that forgets to add libnfnetlink to BuildRequires.



The following changes since commit 21d1283750d9c4df7ca80165d2b9dc0b9bd214eb:
  Jan Engelhardt (1):
        iptables: correctly check for too-long chain/target/match names

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (5):
      doc: libxt_MARK: no longer restricted to mangle table
      doc: remove claim that TCPMSS is limited to mangle
      libxt_recent: add a missing space in output
      doc: add manpage for libxt_osf
      libxt_osf: import nfnl_osf program

 Makefile.am                 |    3 +
 configure.ac                |    8 +-
 extensions/libxt_MARK.man   |    7 +-
 extensions/libxt_TCPMSS.man |    5 +-
 extensions/libxt_osf.c      |    4 +-
 extensions/libxt_osf.man    |   45 +++
 extensions/libxt_recent.c   |    2 +-
 utils/.gitignore            |    1 +
 utils/Makefile.am           |    6 +
 utils/nfnl_osf.c            |  485 ++++++++++++++++++++++++++++++
 utils/pf.os                 |  687 +++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 1242 insertions(+), 11 deletions(-)
 create mode 100644 extensions/libxt_osf.man
 create mode 100644 utils/.gitignore
 create mode 100644 utils/Makefile.am
 create mode 100644 utils/nfnl_osf.c
 create mode 100644 utils/pf.os
