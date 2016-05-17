From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: helper: Fix incorrect helper name.
Date: Tue, 17 May 2016 12:38:42 +0200
Message-ID: <20160517103842.GA3324@salvia>
References: <1463231956-26867-1-git-send-email-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60625 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbcEQKis (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 06:38:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 963C21BD5A2
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:38:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8683F13473E
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:38:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 683F7165CDF
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:38:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463231956-26867-1-git-send-email-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 14, 2016 at 10:19:16PM +0900, Taehee Yoo wrote:
> when register to helper, each helper adds port to name.
> correct form is 'protocol name-port' but irc, sip and tftp adds
> a iterator value. so it fix it.

Could you track since when this works in this way?

This inconsistency has been probably there since long time ago, and we
expose this names through iptables -m helper.

What I mean is: I understand this is inconsistent, but if we change
this now, we may break existing rulesets.
