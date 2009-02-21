From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/6] libxtables: prefix exit_error to xtables_error
Date: Sat, 21 Feb 2009 15:46:25 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902211544460.20889@fbirervta.pbzchgretzou.qr>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de> <1235186284-31661-4-git-send-email-jengelh@medozas.de> <Pine.LNX.4.64.0902210828580.21582@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	hadi@cyberus.ca
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35936 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZBUOq2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Feb 2009 09:46:28 -0500
In-Reply-To: <Pine.LNX.4.64.0902210828580.21582@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-21 08:37, Jesper Dangaard Brouer wrote:
> On Sat, 21 Feb 2009, Jan Engelhardt wrote:
>
>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>> ---
>> extensions/dscp_helper.c        |    4 +-
>> extensions/expr                 |  179 +++++++++++++++++++++++++++++++++++++++
>
> What is "extensions/expr", and what has it to do with "xtables_error" changes?

Mh, `git add .` considered harmful, I should be using git add -u ;-)
Tree is now cleaned with filter-branched;
 + f368d3e...978e27e header-resync -> header-resync (forced update)
 + 85e39ec...4e41854 limits -> limits (forced update)
and
 + 617c80c...da68957 master -> master (forced update)
   > 94 files changed, 778 insertions(+), 788 deletions(-)
