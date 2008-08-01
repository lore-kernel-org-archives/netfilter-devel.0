From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 11/11] Add option to CFLAGS to avoid useless warning.
Date: Fri, 01 Aug 2008 10:34:54 +0200
Message-ID: <4892CAAE.9030408@netfilter.org>
References: <20080723162746.GB31572@bayen.regit.org> <1217166686-28508-12-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35448 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750834AbYHAIfD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2008 04:35:03 -0400
In-Reply-To: <1217166686-28508-12-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds the "-Wno-unused-parameter" option to CFLAGS. This suppress
> gcc warning that can not be fixed due to the usage of generic system like
> callback where function definition has to be standardized.

I have applied this, at least until we find a better way to get the
useful warnings that -Wextra reports.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
