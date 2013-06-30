From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: C++ compile errors
Date: Sun, 30 Jun 2013 18:14:11 +0200
Message-ID: <20130630161411.GA28817@localhost>
References: <51CFDFBE.6050106@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59289 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab3F3QOQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:14:16 -0400
Content-Disposition: inline
In-Reply-To: <51CFDFBE.6050106@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Amos,

On Sun, Jun 30, 2013 at 07:35:26PM +1200, Amos Jeffries wrote:
> Can anyone update me on whether this submission or an equivalent fix
> ever made it into the formal releases? and if so which ones?
> https://lkml.org/lkml/2012/9/30/146

The solution for this is to cache the modified header (that compiles
with C++) in your application source code tree. We cannot take changes
to get C++ application compiling, sorry.

Regards.
