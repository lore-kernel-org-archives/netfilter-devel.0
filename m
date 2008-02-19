From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] NETFILTER:  Make sure xt_policy.h is unifdef'ed.
Date: Tue, 19 Feb 2008 13:30:58 +0100
Message-ID: <47BACC02.70307@trash.net>
References: <alpine.LFD.1.00.0802171231340.8002@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep32-int.chello.at ([62.179.121.50]:34893 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYBSMbO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:31:14 -0500
In-Reply-To: <alpine.LFD.1.00.0802171231340.8002@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Robert P. J. Day wrote:
> Since the header file xt_policy.h tests __KERNEL__, it should be
> unifdef'ed before exporting to userspace.

Applied, thanks.
