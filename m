From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: byte order issue in nf_ct_seqadj_set
Date: Tue, 19 Nov 2013 15:36:08 +0100
Message-ID: <20131119143608.GA7385@localhost>
References: <20131117043745.GA12111@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60733 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab3KSOgN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:36:13 -0500
Content-Disposition: inline
In-Reply-To: <20131117043745.GA12111@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 16, 2013 at 08:37:46PM -0800, Phil Oester wrote:
> In commit 41d73ec053d2, sequence number adjustments were moved to a separate
> file.  Unfortunately, a necessary ntohl call was removed when the call to 
> adjust_tcp_sequence was collapsed into nf_ct_seqadj_set.  As reported by
> Dawid Stawiarsk, this broke the FTP NAT helper.  Add back the byte order
> conversions.

Applied, thanks Phil.
