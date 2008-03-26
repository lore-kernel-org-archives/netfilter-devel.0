From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 3/3] Modify printflow filter to display event type
 in output message.
Date: Wed, 26 Mar 2008 10:34:25 +0100
Message-ID: <47EA18A1.5090002@netfilter.org>
References: <12057124233723-git-send-email-eric@inl.fr> <12057124233697-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39791 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbYCZJed (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:34:33 -0400
In-Reply-To: <12057124233697-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds support of event type display in printflow filter. This is used
> to display event type in textual output modules. Here's an output example:
> 
> [DESTROY] ORIG: SRC=192.168.1.2 DST=192.168.1.255 PROTO=UDP SPT=631 DPT=631 \\
> 	PKTS=1 BYTES=197 , REPLY: SRC=192.168.1.255 DST=192.168.1.2 \\
> 	PROTO=UDP SPT=631 DPT=631 PKTS=0 BYTES=0

Also applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
