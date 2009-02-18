From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] netfilter: suppress now unused nf_log_unregister_pf()
 function.
Date: Wed, 18 Feb 2009 17:10:31 +0100
Message-ID: <499C32F7.4060809@trash.net>
References: <49980BA7.2040108@inl.fr> <1234701437-2754-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56992 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBRQKd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:10:33 -0500
In-Reply-To: <1234701437-2754-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch suppresses the now unused nf_log_unregister_pf() function
> which is as been replaced by the bind and unbind functions.

Please fold this one into patch 1, which already replaces its
use and removes the declaration.
