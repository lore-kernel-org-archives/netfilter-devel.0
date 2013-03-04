From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [ANNOUNCE] conntrack-tools 1.4.1 release
Date: Mon, 04 Mar 2013 10:01:50 -0300
Message-ID: <51349B3E.80205@zacarias.com.ar>
References: <20130303221035.GB28022@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:45854 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3CDNJ3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:09:29 -0500
In-Reply-To: <20130303221035.GB28022@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/03/2013 07:10 PM, Pablo Neira Ayuso wrote:

> Hi!
> 
> The Netfilter project proudly presents:
> 
>         conntrack-tools 1.4.1
> 
> The conntrack-tools are the userspace command line interface
> `conntrack' and the userspace daemon `conntrackd'. The conntrack
> utility replaces the old /proc/net/nf_conntrack interface. With
> conntrack, you can dump, modify and delete entries from the connection
> tracking state table from userspace. On the other hand, conntrackd
> allows you to deploy highly available stateful firewall clusters and
> to run connection tracking helpers from user-space.
> 
> More information in the official manual at:
> http://conntrack-tools.netfilter.org/manual.html
> 
> See ChangeLog that comes attached to this email for more details.
> 
> You can download it from:
> 
> http://www.netfilter.org/projects/nfacct/downloads.html
> ftp://ftp.netfilter.org/pub/nfacct/
> 
> Have fun!

Hi.
There's a little snafu at the moment, it won't build with the current
release version of libnetfilter_conntrack:

******
conntrack.c: In function 'main':
conntrack.c:2005:10: error: 'IPCTNL_MSG_CT_GET_DYING' undeclared (first
use in this function)
conntrack.c:2005:10: note: each undeclared identifier is reported only
once for each function it appears in
conntrack.c:2015:10: error: 'IPCTNL_MSG_CT_GET_UNCONFIRMED' undeclared
(first use in this function)
******

Fixed by http://patchwork.ozlabs.org/patch/202813/ but there's no new
release with the patch applied yet.
Maybe patch configure.ac to check for the new version when it's released?
Regards.

