From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: some questiones about netfilter namespace
Date: Fri, 13 Apr 2012 16:17:03 +0800
Message-ID: <4F87E0FF.9030805@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55505 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2DMIQx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:16:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi pablo

I found there are some netfilter proto's sysctl file is not isolated.
such nf_conntrack_max, nf_conntrack_udp_timeout...

Is this an unimplemented feature ?
Why we make the nf_conntrack_checksum,nf_conntrack_log_invalid..
per-netnamespace, and left nf_conntrack_max?
