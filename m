From: Pierre Chifflier <chifflier@edenwall.com>
Subject: Re: WIP/RFC: add new module ebt_NFQUEUE for ebtables
Date: Fri, 04 Feb 2011 11:05:18 +0100
Message-ID: <4D4BCF5E.8020100@edenwall.com>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-1-git-send-email-chifflier@edenwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:54618 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754043Ab1BDKFV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:05:21 -0500
In-Reply-To: <1296743540-8148-1-git-send-email-chifflier@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/03/2011 03:32 PM, Pierre Chifflier wrote:

> The current problems I'm facing are described in the previous mail,
> and specifically a fault in skb_free, deep inside the br_handle_frame code
> after a reinject.
> I'll try to isolate a backtrace when it happens.
> 

Hi,

The backtrace is more or less the same as the one in Jan's email
<alpine.LNX.2.01.1102031605330.21536@obet.zrqbmnf.qr>
(Kernel crash with repeated NF invocation)

At the moment, I'm wondering if I'm not having several cumulated
problems, which may be triggered more easily by my modifications ...

Pierre
