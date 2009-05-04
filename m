From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables pull request
Date: Mon, 04 May 2009 15:23:38 +0200
Message-ID: <49FEEC5A.3080409@netfilter.org>
References: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59421 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbZEDNXt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2009 09:23:49 -0400
In-Reply-To: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Please pull from:
>         git://dev.medozas.de/iptables  master
> 
> to receive 1 external submission, 1 manpage completion, and 7 code
> transformations intended for the 1.4.4 'branch'.

There are several API changes in this changeset, could you justify the
benefits of it? I think that they may break binary compatibility. I
think that the idea was to provide a stable API for things like jamal's
ipt, not to change it quite so often just to replace int by bool.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
