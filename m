From: Patrick McHardy <kaber@trash.net>
Subject: Re: [libnetfilter_log PATCH] Add parsing function for raw hardware
 header.
Date: Thu, 17 Jul 2008 11:13:38 +0200
Message-ID: <487F0D42.90500@trash.net>
References: <487CA584.3030200@trash.net> <1216247346-21553-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49890 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbYGQJNm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:13:42 -0400
In-Reply-To: <1216247346-21553-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds support for the parsing of NFULA_HWTYPE, NFULA_HWHEADER,
> and NFULA_HWLEN part of the NFLOG message. This permits to have a ULOG
> like behaviour but thanks to NFULA_HWTYPE we will be able to parse the
> message cleanly in userspace.

Applied, thanks.
