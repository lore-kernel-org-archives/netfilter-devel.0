From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: Implement RFC 1123 for FTP conntrack
Date: Fri, 6 May 2011 19:45:49 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105061943560.22432@obet.zrqbmnf.qr>
References: <4DC4322C.2020602@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55118 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab1EFRpv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 May 2011 13:45:51 -0400
In-Reply-To: <4DC4322C.2020602@suse.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-05-06 19:38, Jeff Mahoney wrote:

>The FTP conntrack code currently only accepts the following format for
>the 227 response for PASV:
>227 Entering Passive Mode (148,100,81,40,31,161).
>
>It doesn't accept the following format from an obscure server:
>227 Data transfer will passively listen to 67,218,99,134,50,144
>
>From RFC 1123: The format of the 227 reply to a PASV command is not 
>well standardized.  In particular, an FTP client cannot assume that the 
>parentheses shown on page 40 of RFC-959 will be present (and in fact, 
>Figure 3 on page 43 omits them).  Therefore, a User-FTP program that 
>interprets the PASV reply must scan the reply for the first digit of 
>the host and port numbers.
>
>This patch adds support for the RFC 1123 clarification[...]
>
>Tracked in: https://bugzilla.novell.com/show_bug.cgi?id=466279

"You are not authorized to access bug #466279."
