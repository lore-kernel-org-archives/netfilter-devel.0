From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] Add all necessary header files - compilation fix
 for various cases
Date: Sun, 13 Apr 2008 10:29:28 +0200
Message-ID: <4801C468.3030306@trash.net>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <e6284a55b23e8efcb568672c4e49dee2e98cbf4e.1208075035.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37015 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYDMIcw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:32:52 -0400
In-Reply-To: <e6284a55b23e8efcb568672c4e49dee2e98cbf4e.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Allow iptables to compile without a kernel source tree. This
> implies fixing build for older kernels, such as 2.6.17 which
> lack xt_SECMARK.h.

My question is still open - what version are these headers
based on. Or differently asked: do they include anything not
merged upstream yet?

