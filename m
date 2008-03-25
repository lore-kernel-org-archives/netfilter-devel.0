From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/8] Add hook to list of fields in database for
 packet logging.
Date: Tue, 25 Mar 2008 09:41:20 +0100
Message-ID: <47E8BAB0.70900@netfilter.org>
References: <12051021893015-git-send-email-eric@inl.fr> <12051021891470-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57486 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754755AbYCYIli (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:41:38 -0400
In-Reply-To: <12051021891470-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds oob.hook to the list of fields export to the databases. This
> adds the capability to know where the packet has been logged and will be used
> to make a link between connection and logged packets.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
