From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2] basic patches
Date: Mon, 20 Oct 2008 14:04:56 +0200
Message-ID: <48FC73E8.7070008@netfilter.org>
References: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49435 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751955AbYJTMFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:05:05 -0400
In-Reply-To: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pierre Chifflier wrote:
> Hi,
> 
> These patchset fix the following problems:
> 
> - We don't need to add constraints in the PostgreSQL table, the application
>   already checks for port value. Constraints only slow down insertions.
> 
> - Finish the renaming of MAC2STR plugin to HWHDR
> 
> - Fix a potential segfault in HWHDR plugin, when mac is NULL (e.g when using
>   ulogd2 on OUTPUT).

All applied. Thanks Pierre. BTW, next time, it would great if you can
improve the log a bit to look like:

-o-
section: short description

Long description

Signed-off-by: Dorian Gray <dorian@wilde.org>
-o-

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
