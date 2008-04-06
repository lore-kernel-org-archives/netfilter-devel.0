From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/24] Correct the family member value of libxt_mark revision
 1
Date: Sun, 06 Apr 2008 17:31:55 +0200
Message-ID: <47F8ECEB.5060609@trash.net>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de> <e64620b8cc13342ae6d91ab532ba89f0bcbe8b32.1207495183.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37149 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYDFPbr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:31:47 -0400
In-Reply-To: <e64620b8cc13342ae6d91ab532ba89f0bcbe8b32.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> libxt_mark rev1 used AF_INET6 in the class structure where it should
> have used AF_INET.

Applied.
