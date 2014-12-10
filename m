From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] Fix file descriptor leak in
 channel_open() on error
Date: Thu, 11 Dec 2014 00:36:36 +0100
Message-ID: <20141210233636.GA3720@salvia>
References: <5488C193.2030707@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44229 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbaLJXeQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:34:16 -0500
Content-Disposition: inline
In-Reply-To: <5488C193.2030707@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 10, 2014 at 10:56:35PM +0100, Thomas Jarosch wrote:
> Detected by cppcheck

Applied, thanks Thomas.
