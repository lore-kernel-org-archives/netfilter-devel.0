From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/7] autotool conversion: converted the subdir. 'src/'
Date: Thu, 10 Jul 2014 12:08:35 +0200
Message-ID: <20140710100835.GA4753@localhost>
References: <1404742796-8039-1-git-send-email-giorgio.nicole@arcor.de>
 <1404742796-8039-4-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57643 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbaGJKIp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:08:45 -0400
Content-Disposition: inline
In-Reply-To: <1404742796-8039-4-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 07, 2014 at 04:19:27PM +0200, Giorgio Dal Molin wrote:
>  src/parser.y      | 2251 -----------------------------------------------------
>  src/yacc_parser.y | 2251 +++++++++++++++++++++++++++++++++++++++++++++++++++++

Could you resend this patch using -M90% with git-format-patch so it
can detect the file rename and we make sure no new code accidentally
slipped through?

Thanks.
