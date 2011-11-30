From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: nat drop the icmp redirect packet
Date: Wed, 30 Nov 2011 12:00:14 +0800
Message-ID: <4ED5AA4E.2010604@cn.fujitsu.com>
References: <4ED2E00B.3000006@cn.fujitsu.com> <4ED2E2A4.6000505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64538 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1K3D73 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Nov 2011 22:59:29 -0500
In-Reply-To: <4ED2E2A4.6000505@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi pablo
what's your idea?

> 
> or maybe we can move the ip_rt_send_redirect from FORWARD to POSTROUTING?
> --

