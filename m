From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [patch 1/1] Add subsystem accessors
Date: Fri, 01 Feb 2008 18:13:46 +0100
Message-ID: <47A3534A.90006@astaro.com>
References: <20080130182128.826992459@kruemel.intranet.astaro.de> <20080130182454.607358723@kruemel.intranet.astaro.de> <47A34FD8.2080806@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-29.dex002.intermedia.net ([64.78.21.73]:43520 "EHLO
	dhost002-29.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756013AbYBAROB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:14:01 -0500
In-Reply-To: <47A34FD8.2080806@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:

>> Need by newer ulogd v2.
> 
> Why do you need this? If I apply this, I'll have to provide support for
> people mixing calls to libnfnetlink and libnetfilter_conntrack which can
> be a problematic. The subsys handles are encapsulated for that reason.
> 
> If you really need them, I suggest you to use libnfnetlink together with
> the low level functions libnetfilter_conntrack functions:
> nfct_[build|parse]_conntrack and nfct_build_query.

Which would nullify the use of libnetfilter-conntrack with ulogd.

BTW, after using the new libnetfilter-conntrack I get this:

  ulogd_inpflow_NFCT.c:455: warning: passing argument 1 of 'nfnl_send'
   discards qualifiers from pointer target type
ulogd_inpflow_NFCT.c: In function 'read_cb_nfct':
  ulogd_inpflow_NFCT.c:1043: warning: passing argument 1 of 
'nfnl_recv_msgs' discards qualifiers from pointer target type
  ulogd_inpflow_NFCT.c: In function 'nfct_start':
ulogd_inpflow_NFCT.c:1156: warning: passing argument 1 of
  'nfnl_rcvbufsiz' discards qualifiers from pointer target type
ulogd_inpflow_NFCT.c: In function 'read_cb_nfct':
  ulogd_inpflow_NFCT.c:1043: warning: passing argument 1 of 
'nfnl_recv_msgs' discards qualifiers from pointer target type
...

Do you accept patches for that or should I just cast-away the wrong 
const there?

  /holger
