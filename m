From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] build: rename conflicting parser.h instances
Date: Tue, 19 Nov 2013 21:25:34 +0100
Message-ID: <20131119202534.GB4929@localhost>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de>
 <1382280491-9921-3-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44777 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3KSUZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:25:38 -0500
Content-Disposition: inline
In-Reply-To: <1382280491-9921-3-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 20, 2013 at 04:48:10PM +0200, Jan Engelhardt wrote:
> If -I. is on the command line, #include <parser.h> becomes ./parser.h
> instead of ../include/parser.h.

What use case are you trying to handle with this?
