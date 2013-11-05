From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4] build: avoid inclusion of stdbool.h in C++
Date: Tue, 5 Nov 2013 13:57:29 +0100
Message-ID: <20131105125729.GC29010@localhost>
References: <1382963240-18760-1-git-send-email-jengelh@inai.de>
 <1382963240-18760-4-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54546 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab3KEM5e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:57:34 -0500
Content-Disposition: inline
In-Reply-To: <1382963240-18760-4-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 28, 2013 at 01:27:19PM +0100, Jan Engelhardt wrote:
> C++ does not need this header, as it already has bool builtin.

This works fine with g++ as is at this moment.

Do you plan to compile libnftables using a different compiler?
