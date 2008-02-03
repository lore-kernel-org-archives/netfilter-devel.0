From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 07/34]  Changed sighup_handler_print to fallback to continue
 using old descriptor on new file opening failure.
Date: Sun, 03 Feb 2008 12:35:19 +0100
Message-ID: <47A5A6F7.6030003@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <12019874692227-git-send-email-eric@inl.fr> <12019874701613-git-send-email-eric@inl.fr> <12019874702005-git-send-email-eric@inl.fr> <12019874703998-git-send-email-eric@inl.fr> <12019874701589-git-send-email-eric@inl.fr> <12019874701366-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48130 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750835AbYBCLfb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:35:31 -0500
In-Reply-To: <12019874701366-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch is a backport of Marius Tomaschewski <mt@suse.de> work on ulogd.

I like these backports. Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
