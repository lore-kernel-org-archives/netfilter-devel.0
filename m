From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ulogd2 PATCH] Fix bracket imbalance if IPPROTO_SCTP is
 defined
Date: Fri, 3 Aug 2012 20:34:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208032034020.29800@frira.zrqbmnf.qr>
References: <4E552746.4020000@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:35977 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab2HCSeY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:34:24 -0400
In-Reply-To: <4E552746.4020000@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-08-24 18:31, Thomas Jarosch wrote:

>Detected by cppcheck.

This is still applicable.

>diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
>index 025faab..f7856d2 100644
>--- a/output/ulogd_output_IPFIX.c
>+++ b/output/ulogd_output_IPFIX.c
>@@ -406,6 +406,7 @@ static int open_connect_socket(struct ulogd_pluginstance *pi)
> 				freeaddrinfo(resave);
> 				return ret;
> 			}
>+		}
> #endif
> 
> 		if (connect(ii->fd, res->ai_addr, res->ai_addrlen) != 0) {
>-- 
>1.7.4.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
