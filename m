From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 5/8] Add a list of used plugininstance.
Date: Tue, 25 Mar 2008 10:50:25 +0100
Message-ID: <47E8CAE1.2080402@netfilter.org>
References: <12051021893015-git-send-email-eric@inl.fr> <12051021893531-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53745 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752517AbYCYJuc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 05:50:32 -0400
In-Reply-To: <12051021893531-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds plist a linked list to the pluginstance
> structure. It can be used by input modules to duplicate an
> entry. This solves the issue of not being able to use the same
> plugin instance twice.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
