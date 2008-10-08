From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [iptables PATCH 1/2] [TPROXY] Add userspace component of	the
	TPROXY target
Date: Wed, 08 Oct 2008 09:21:17 +0200
Message-ID: <1223450477.7554.8.camel@nessa.odu>
References: <1223450379.7554.3.camel@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:56843 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbYJHHVT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:21:19 -0400
Received: from [192.168.1.103] ([89.132.101.55])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTPSA id <0K8E008M5SEE3CF0@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Wed, 08 Oct 2008 09:20:38 +0200 (CEST)
In-reply-to: <1223450379.7554.3.camel@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is an accidental resend of the same patch, please ignore it.

On Wed, 2008-10-08 at 09:19 +0200, KOVACS Krisztian wrote:
> Add `TPROXY' target.
> 
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
> ---
> 
>  extensions/libxt_TPROXY.c           |  155
> +++++++++++++++++++++++++++++++++++
>  extensions/libxt_TPROXY.man         |   21 +++++
>  include/linux/netfilter/xt_TPROXY.h |   14 +++
>  3 files changed, 190 insertions(+), 0 deletions(-)
>  create mode 100644 extensions/libxt_TPROXY.c
>  create mode 100644 extensions/libxt_TPROXY.man
>  create mode 100644 include/linux/netfilter/xt_TPROXY.h
> [...]

-- 
KOVACS Krisztian

