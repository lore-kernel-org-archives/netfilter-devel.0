From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 2/8] Introduce RAWSTR type to avoid confusion in
 future developement.
Date: Tue, 25 Mar 2008 09:42:21 +0100
Message-ID: <47E8BAED.5010603@netfilter.org>
References: <12051021893015-git-send-email-eric@inl.fr> <12051021893499-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52644 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbYCYIma (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:42:30 -0400
In-Reply-To: <12051021893499-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> IP2BIN filter convert IP address from host storage to a "binary" string which
> can be use by MySQL. This is not strictly speaking raw data but it was of type
> RAW.
> 
> Following remark from Hugo Mildenberger, I introduce in this patch a dedicated
> type ULOGD_RET_RAWSTR. The main reason not to use a ULOGD_RET_STRING parameter
> is that the paramater is not human readable.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
