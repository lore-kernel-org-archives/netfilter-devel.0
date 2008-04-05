From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 14/14] Fix computation of length of mac address.
Date: Sat, 05 Apr 2008 16:56:36 +0200
Message-ID: <47F79324.6070608@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895232871-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40060 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097AbYDEO4n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 10:56:43 -0400
In-Reply-To: <12062895232871-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Length of MAC address was set to big and thus display was wrong. This
> misbehaviour was also causing to read datas out of the correct range.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
