From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] Add all necessary header files - compilation fix
 for various cases
Date: Mon, 14 Apr 2008 08:40:45 +0200
Message-ID: <4802FC6D.5090107@trash.net>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <e6284a55b23e8efcb568672c4e49dee2e98cbf4e.1208075035.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63189 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYDNGku (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:40:50 -0400
In-Reply-To: <e6284a55b23e8efcb568672c4e49dee2e98cbf4e.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Allow iptables to compile without a kernel source tree. This
> implies fixing build for older kernels, such as 2.6.17 which
> lack xt_SECMARK.h.


Applied including the extra chunk you sent seperate mail.
