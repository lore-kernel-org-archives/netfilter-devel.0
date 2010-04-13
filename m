From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
 finding.
Date: Tue, 13 Apr 2010 12:09:41 +0200
Message-ID: <4BC442E5.8020001@trash.net>
References: <4BBEA97A.5020303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46135 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0DMKJn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:09:43 -0400
In-Reply-To: <4BBEA97A.5020303@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> use hash table to speed up entry finding.
> 
> If verdicts aren't received in order, list isn't efficient, and hash
> table is better.

Any what is the advantage of using flex arrays compared to a simple
open code hash table?
