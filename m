From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: valgrind warning in libnetfilter_log.c
Date: Tue, 25 Mar 2008 11:24:28 +0100
Message-ID: <47E8D2DC.9090108@netfilter.org>
References: <200803241447.41041.Hugo.Mildenberger@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Hugo Mildenberger <Hugo.Mildenberger@t-online.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40979 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752229AbYCYKYj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:24:39 -0400
In-Reply-To: <200803241447.41041.Hugo.Mildenberger@t-online.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hugo Mildenberger wrote:
> The warning  could not be suppressed by zeroing the message buffer in 
> nflog_setmode, but it could be suppressed by zeroing  struct 
> nfulnl_msg_config_mode params: 
> 
> excerpt from libnetfilter_log/linux_nfnetlink_log.h:
> struct nfulnl_msg_config_mode {
>         u_int32_t       copy_range;
>         u_int8_t        copy_mode;
>         u_int8_t        _pad;
> } __attribute__ ((packed));
> 
> Therefore, this warning is caused by "_pad" remaining uninitialised. 
> Referencing "_pad" explicitely would be  somewhat unpleasant. Using memset 
> would induce additional computation only to suppress a warning. Best solution 
> would be to extend .copy_mode from u_int8_t to u_int16_t and drop ._pad 
> completely. There are more issues like that in linux_nfnetlink_log.h. I 
> wonder why this approach was choosen to achieve 16-bit alignment: "_pad " 
> will be transmitted anyway.

AFAICS, we can run into backward compatibility issues if remove _pad by
extending copy_mode. Hugo, I'd appreciate a patch that uses memset so
that we get rid of this warning.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
