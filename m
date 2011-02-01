From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] bugfixes for nf-next-2.6 (2.6.38-rc)
Date: Tue, 01 Feb 2011 13:45:26 +0100
Message-ID: <4D480066.5000402@trash.net>
References: <20110201120116.3427.96097.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41650 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab1BAMp2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:45:28 -0500
In-Reply-To: <20110201120116.3427.96097.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 01.02.2011 13:05, schrieb Pablo Neira Ayuso:
> Hi Patrick!
> 
> I've got a couple of patches for nf-next-2.6. The first fixes
> arptables that seems to be broken since quite some time due
> to a broken cleanup. The latter refers to the CT event filtering,
> I think it can be qualified as bugfix since the current filtering
> schema is not useful for conntrackd.

The subject is contradictional, nf-next-2.6/net-next-2.6 will be
merged once 2.6.38 is released, not for 2.6.38-rc. I suppose these
fixes should go into nf-2.6.git for 2.6.38-rc?
