From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack/libnetfilter_conntrack build warnings/errors
Date: Sun, 09 Dec 2007 18:25:22 +0100
Message-ID: <475C2502.5090703@netfilter.org>
References: <Pine.LNX.4.64.0712091318110.17491@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45075 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbXLIRZk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:25:40 -0500
In-Reply-To: <Pine.LNX.4.64.0712091318110.17491@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Jan Engelhardt wrote:
>   CC       deprecated.lo
> deprecated.c: In function 'nfct_sprintf_conntrack':
> deprecated.c:567: warning: 'nfct_sprintf_protocol' is deprecated (declared at deprecated.c:492)
> deprecated.c:570: warning: 'nfct_sprintf_timeout' is deprecated (declared at deprecated.c:500)
> [...]

These warnings are supposed to be normal, I moved the old
libnetfilter_conntrack API to the file deprecated.c and added the
deprecated attribute to warn people that they are using a deprecated
API. Thus, whoever using very old conntrack-tools versions or using the
old API may move to new versions of the tools or use the new API. I'm
thinking about removing the old libnetfilter_conntrack API in 6 months.

>   CCLD     conntrack_events
> make[1]: *** No rule to make target `conntrack_master.o', needed by `conntrack_master'.  Stop.
> make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/utils'
> make: *** [all-recursive] Error 1
> error: Bad exit status from /var/tmp/rpm-tmp.7694 (%build)

I forgot to commit utils/conntrack_master.c to SVN. Now it's fixed. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
