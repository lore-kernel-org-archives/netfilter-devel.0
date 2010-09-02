From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: TCP proto info
Date: Thu, 02 Sep 2010 10:57:39 +0200
Message-ID: <4C7F6703.2080704@netfilter.org>
References: <OF9D26EAF2.D88996EC-ONC1257791.00499961-C1257791.004BB4FC@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: rui.sousa@mindspeed.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33129 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab0IBJE0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Sep 2010 05:04:26 -0400
In-Reply-To: <OF9D26EAF2.D88996EC-ONC1257791.00499961-C1257791.004BB4FC@mindspeed.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Rui,

On 01/09/10 15:45, rui.sousa@mindspeed.com wrote:
> Hi,
> 
> I have an application using libnetfilter_conntrack-0.100 that started 
> reporting errors after the commit: 
> 
> 1c450e1595afdc8d1bfabb4f640c9251808426eb.

Looking at the source code, this seems to be already fixed in
libnetfilter_conntrack 0.0.102, please upgrade to latest.
