From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: fix file list warning with automake-1.9
Date: Tue, 09 Aug 2011 14:37:23 +0200
Message-ID: <4E412A03.8050004@netfilter.org>
References: <1312384217-26670-1-git-send-email-jengelh@medozas.de> <1312384217-26670-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49622 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab1HIMh0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:37:26 -0400
In-Reply-To: <1312384217-26670-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/08/11 17:10, Jan Engelhardt wrote:
> Makefile.am:12: EXTRA_DIST multiply defined in condition TRUE ...
> Makefile.am:3: ... "EXTRA_DIST" previously defined here
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

applied, thanks
