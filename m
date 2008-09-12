From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 0/3] cleaning and build feature
Date: Fri, 12 Sep 2008 03:24:39 +0200
Message-ID: <48C9C4D7.40904@netfilter.org>
References: <> <1221166085-23435-1-git-send-email-eric@inl.fr> <48C9AE94.1000208@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43004 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752801AbYILBaA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 21:30:00 -0400
In-Reply-To: <48C9AE94.1000208@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
>> Am I missing something ?
> 
> I have added BSF support to libnetfilter_conntrack. This could be
> interesting to filter ctnetlink event messages from kernel-space. You
> can find an example in the configuration file of conntrackd, see the
> Filter clause.
> 
> The problem is the current configuration file format which is quite
> cryptic. Using something flex/bison-based would be more flexible, but we
> have to think about the file format before.
> 
> I have other concerns, I'm willing to schedule some time for ulogd to
> make a new TODO list, we can probably discuss them during the workshop.

I forgot to mention that the IPFIX plugin is currently broken.
-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
