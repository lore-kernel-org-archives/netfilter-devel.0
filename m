From: Patrick McHardy <kaber@trash.net>
Subject: Re: [pull] all patches complete
Date: Mon, 16 Feb 2009 11:41:07 +0100
Message-ID: <499942C3.1090906@trash.net>
References: <alpine.LSU.2.00.0902131642300.17695@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZBPKlL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:41:11 -0500
In-Reply-To: <alpine.LSU.2.00.0902131642300.17695@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> All patches have been gathered and collected, pullable at the usual 
> place of
> 	git://dev.medozas.de/iptables master
>
>  20 files changed, 180 insertions(+), 173 deletions(-)

I wanted to pull this, but I'm again getting a quite different
diffstat:

  Makefile.am                    |    8 +-
  configure.ac                   |    3 +-
  extensions/libxt_multiport.man |    4 +-
  include/Makefile.am            |    8 +++
  include/ip6tables.h            |    2 +
  include/iptables.h             |    2 +
  include/xtables.h.in           |   10 +++-
  ip6tables-restore.c            |   31 +++++++----
  ip6tables-save.c               |   14 +++--
  ip6tables-standalone.c         |   13 +++--
  ip6tables.c                    |   89 ++++++----------------------
  iptables-restore.8             |    1 -
  iptables-restore.c             |   27 +++++----
  iptables-save.c                |   14 +++--
  iptables-standalone.c          |   14 +++--
  iptables-xml.c                 |   32 +++++------
  iptables.c                     |   94 +++++++-----------------------
  libipq/Makefile.am             |    1 -
  libipq/ipq_set_verdict.3       |    7 ++
  libipq/libipq.c                |    2 +
  xtables.c                      |  124 
+++++++++++++++++++++++++++-------------
  21 files changed, 242 insertions(+), 258 deletions(-)
  create mode 100644 include/Makefile.am
