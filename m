From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 05/31] netfilter: Auto-load ip6_queue module when socket
 opened.
Date: Mon, 16 Mar 2009 15:30:54 +0100
Message-ID: <49BE629E.9080604@trash.net>
References: <cover.1236702228.git.scott@canonical.com> <1ac10308df52b2e58c3a77313d3608c1a130341f.1236702228.git.scott@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Scott James Remnant <scott@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46673 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbZCPOa6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:30:58 -0400
In-Reply-To: <1ac10308df52b2e58c3a77313d3608c1a130341f.1236702228.git.scott@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Scott James Remnant wrote:
> The ip6_queue module is missing the net-pf-16-proto-13 alias that would
> cause it to be auto-loaded when a socket of that type is opened.  This
> patch adds the alias.

Applied, thanks.
