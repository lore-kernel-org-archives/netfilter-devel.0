From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: seqadj: print the host byte order ack seq
Date: Mon, 5 Jan 2015 13:58:47 +0100
Message-ID: <20150105125847.GA5298@salvia>
References: <1419500829-9523-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1419841331-21299-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43778 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbbAEM4D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:56:03 -0500
Content-Disposition: inline
In-Reply-To: <1419841331-21299-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 29, 2014 at 04:22:11PM +0800, Gao feng wrote:
> new_start_seq and new_end_seq are network byte order,
> print the host byte order in debug message and print
> seq number as the type of unsigned int.

Applied, thanks.
