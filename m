From: Jiri Pirko <jpirko@redhat.com>
Subject: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 11:12:58 +0100
Message-ID: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, coreteam@netfilter.org, netfilter@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758973Ab0BYKNL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:13:11 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.

I want to ask if there is any particular reason for ipt_CLUSTERIP to support
only address length of 6 (ETH_ALEN)? It seems to me reasonable for this to work
even with another types of network hw with different addr_len.

Thanks.

Jirka
