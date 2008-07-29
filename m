From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 1/2] Add hardware address parsing to MAC2STR.
Date: Tue, 29 Jul 2008 12:18:09 +0200
Message-ID: <488EEE61.5090503@netfilter.org>
References: <20080724171600.GA23670@khasse.inl.fr> <1217087028-1136-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54988 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757646AbYG2KSR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:18:17 -0400
In-Reply-To: <1217087028-1136-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies the MAC2STR plugin to be able convert hardware
> address related fields to string:
>  * raw.mac -> mac.str
>  * raw.mac.saddr -> mac.saddr.str
> It is able to parse ethernet header. For ethernet
> we have the following conversion:
>  * raw.mac ->
>  	* mac.saddr.str
> 	* mac.daddr.str
> 	* oob.protocol
> Output modules need to have raw.type. In case, ethernet is detected, this
> field is set to ethernet and sent to output by the module.

I have applied this patch. However, I have noticed that this patch still
does probing based on the header and field sizes for the ULOG case.
Since we now have the full link layer header via NFLOG (>= 2.6.27) and
ULOG is deprecated, I still don't quite understand why we should put any
effort on this. Actually, I may cook a patch to remove such probing.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
