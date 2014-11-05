From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] netfilter: bridge: unshare bridge info before change
 it
Date: Wed, 5 Nov 2014 10:13:17 +0800
Message-ID: <545987BD.8090400@cn.fujitsu.com>
References: <1411976114-16812-1-git-send-email-gaofeng@cn.fujitsu.com> <54582195.20209@cn.fujitsu.com> <20141104190055.GA27683@salvia> <545984E6.5050801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30380 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752850AbaKECNU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:13:20 -0500
In-Reply-To: <545984E6.5050801@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/05/2014 10:01 AM, Gao feng wrote:
> On 11/05/2014 03:00 AM, Pablo Neira Ayuso wrote:

> but __copy_skb_header may be called in the scene I described above,

I mean __copy_skb_header between br_nf_pre_routing and br_nf_pre_routing_finish
