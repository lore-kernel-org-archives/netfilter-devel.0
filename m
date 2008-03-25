From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] Fix reply direction for both ICMP and ICMPv6 in libnetfilter_conntrack
Date: Tue, 25 Mar 2008 15:27:16 +0100
Message-ID: <47E90BC4.7040101@netfilter.org>
References: <47e70c6f.pDuHAR+deWCgDmcZ%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35765 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754001AbYCYO1W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:27:22 -0400
In-Reply-To: <47e70c6f.pDuHAR+deWCgDmcZ%ole@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> This patch adds invmap support and duplicate code/id for reply direction,
> so inserted conntracks get proper type, code and id. Without this fix
> "type", "code" and "id" in reply direction were always set to 0. It "automagically"
> worked for ICMP and ICMP_ECHOREPLY (ICMP_ECHOREPLY==8 -> ICMP_ECHO==*0*),
> but not with with other ICMP codes nor with ICMPv6.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
