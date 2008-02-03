From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 17/34]  Suppress key relative to IPv6 address.
Date: Sun, 03 Feb 2008 12:59:01 +0100
Message-ID: <47A5AC85.4070408@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <12019874692227-git-send-email-eric@inl.fr> <12019874701613-git-send-email-eric@inl.fr> <12019874702005-git-send-email-eric@inl.fr> <12019874703998-git-send-email-eric@inl.fr> <12019874701589-git-send-email-eric@inl.fr> <12019874701366-git-send-email-eric@inl.fr> <12019874704144-git-send-email-eric@inl.fr> <12019874703136-git-send-email-eric@inl.fr> <12019874701552-git-send-email-eric@inl.fr> <12019874701370-git-send-email-eric@inl.fr> <12019874702349-git-send-email-eric@inl.fr> <12019874703504-git-send-email-eric@inl.fr> <12019874704067-git-send-email-eric@inl.fr> <12019874703897-git-send-email-eric@inl.fr> <12019874712066-git-send-email-eric@inl.fr> <1201987471474-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45602 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759382AbYBCL7V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:59:21 -0500
In-Reply-To: <1201987471474-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> From: Eric leblond <eric@inl.fr>
> 
> This patch suppress key relative to IPv6 address because IPv4 and IPv6 can 
> be stored in the same key.

Applied. Thanks. I have also added a minor comment to the changelog
about the missing IP2STR from ulogd.conf.in line that it also include in
this patch.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
