From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: multiprimary conntrackd setup
Date: Wed, 06 May 2009 13:03:21 +0200
Message-ID: <4A016E79.5050107@netfilter.org>
References: <m37i5lmgtj.fsf@neo.luffy.cx> <4957E54C.3070500@netfilter.org>	<m33ag8kmei.fsf@neo.luffy.cx> <497F251E.5030106@netfilter.org> <m3d4bwp505.fsf@neo.luffy.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Vincent Bernat <bernat@luffy.cx>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42354 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbZEFLDa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2009 07:03:30 -0400
In-Reply-To: <m3d4bwp505.fsf@neo.luffy.cx>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Vincent,

Vincent Bernat wrote:
> I have seen that kernel part has  been pushed to 2.6.30 but I don't find
> the  iptables part. Your  latest patch  for iptables  in netfilter-devel
> still   contains  node_id   instead  of   node_mask  and   proc_name  in
> xt_cluster_match_info. Did you put somewhere a patch against iptables?

I have just applied it to the iptables' git tree.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
