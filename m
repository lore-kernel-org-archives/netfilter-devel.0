From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ftp: Check data size before copy them
 into FTP buffer
Date: Sun, 4 Oct 2015 22:16:20 +0200
Message-ID: <20151004201620.GA30723@salvia>
References: <BAY403-EAS3244BB5B8769FABE83B01EF954E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47787 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbbJDUJZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Oct 2015 16:09:25 -0400
Content-Disposition: inline
In-Reply-To: <BAY403-EAS3244BB5B8769FABE83B01EF954E0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 29, 2015 at 04:49:32PM +0800, Feng Gao wrote:
> When TCP endpoint supports the windows scale option, the data size could
> be more than 65536 easily. And there are some network interface features
> which could aggregate multiple packets. So we need to check the datalen
> before copy data into the FTP buffer.

I don't think you can go over the maximum IPv4/IPv6 packet length with
aggregation.
