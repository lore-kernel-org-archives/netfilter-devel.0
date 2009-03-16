From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 04/31] netfilter: Auto-load ip_queue module when socket
 opened.
Date: Mon, 16 Mar 2009 15:31:46 +0100
Message-ID: <49BE62D2.7060703@trash.net>
References: <cover.1236702228.git.scott@canonical.com> <cad3a5b11d97ba57d8a5e4df605ed55324e2b734.1236702228.git.scott@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Scott James Remnant <scott@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46702 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbZCPObt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:31:49 -0400
In-Reply-To: <cad3a5b11d97ba57d8a5e4df605ed55324e2b734.1236702228.git.scott@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Scott James Remnant wrote:
> The ip_queue module is missing the net-pf-16-proto-3 alias that would
> causae it to be auto-loaded when a socket of that type is opened.  This
> patch adds the alias.

Also applied, thanks.
