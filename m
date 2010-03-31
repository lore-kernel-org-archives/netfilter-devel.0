From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: obsolete old extension revisions
Date: Wed, 31 Mar 2010 08:07:01 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1003310804450.31767@obet.zrqbmnf.qr>
References: <1269533065-22318-1-git-send-email-jengelh@medozas.de> <4BB2E4E8.1070809@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39828 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab0CaGHD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:07:03 -0400
In-Reply-To: <4BB2E4E8.1070809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-31 08:00, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> (JFYI, the next pull group will be hashlimit v0 removal.)
>> 
>> The following changes since commit 5dc7a6d5749d3ddbf9fbea9512cb45762428512c:
>>   Jan Engelhardt (1):
>>         netfilter: xt_recent: allow changing ip_list_[ug]id at runtime


The following changes since commit f95c74e33eff5e3fe9798e2dc0a7749150ea3f80:
  Jan Engelhardt (1):
        netfilter: xtables: shorten up return clause

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (4):
      netfilter: xtables: remove xt_hashlimit revision 0
      netfilter: xtables: remove xt_multiport revision 0
      netfilter: xtables: remove xt_string revision 0
      netfilter: xtables: merge registration structure to NFPROTO_UNSPEC

 Documentation/Changes        |    2 +-
 net/netfilter/xt_hashlimit.c |  221 ------------------------------------------
 net/netfilter/xt_multiport.c |   77 ---------------
 net/netfilter/xt_state.c     |   31 ++----
 net/netfilter/xt_string.c    |   53 ++++-------
 5 files changed, 29 insertions(+), 355 deletions(-)
