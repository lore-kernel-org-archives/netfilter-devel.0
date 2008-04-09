From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 2/4] Convert SQL procedure to function in MySQL
 plugins.
Date: Wed, 09 Apr 2008 15:36:28 +0200
Message-ID: <47FCC65C.6090100@netfilter.org>
References: <1207004990315-git-send-email-eric@inl.fr> <1207004990860-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34807 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752463AbYDINgj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:36:39 -0400
In-Reply-To: <1207004990860-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> DB output plugins have been modified to use function instead of procedure.
> This patch convert the conntrack insertion procedure to function.

Where is the client code that uses the returned value of the INSERT_CT
function?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
