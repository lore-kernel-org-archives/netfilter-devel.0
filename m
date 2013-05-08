From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: iptables upgrade: netmask parsing trouble
Date: Wed, 08 May 2013 17:01:13 +0200
Message-ID: <1764925.ueeBFl1d2D@storm>
References: <1548294.4rj9RFaJ57@storm> <20130508131016.GA3921@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:59181 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3EHPBQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 11:01:16 -0400
In-Reply-To: <20130508131016.GA3921@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday, 8. May 2013 15:10:16 you wrote:
> > Any reason why we don't accept the full format anymore?
> 
> No. Things that used to work have to work indeed. Just sent a patch to
> fix it.

patch seems to work fine (=loads the firewall again).
Thanks for the quick fix.

Thomas

