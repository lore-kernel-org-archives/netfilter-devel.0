From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] conntrack-tools 1.4.1 release
Date: Mon, 4 Mar 2013 14:36:27 +0100
Message-ID: <20130304133627.GA1170@localhost>
References: <20130303221035.GB28022@localhost>
 <51349B3E.80205@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45056 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab3CDNgh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:36:37 -0500
Content-Disposition: inline
In-Reply-To: <51349B3E.80205@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 04, 2013 at 10:01:50AM -0300, Gustavo Zacarias wrote:
> On 03/03/2013 07:10 PM, Pablo Neira Ayuso wrote:
> 
> > Hi!
> > 
> > The Netfilter project proudly presents:
> > 
> >         conntrack-tools 1.4.1
> > 
> > The conntrack-tools are the userspace command line interface
> > `conntrack' and the userspace daemon `conntrackd'. The conntrack
> > utility replaces the old /proc/net/nf_conntrack interface. With
> > conntrack, you can dump, modify and delete entries from the connection
> > tracking state table from userspace. On the other hand, conntrackd
> > allows you to deploy highly available stateful firewall clusters and
> > to run connection tracking helpers from user-space.
> > 
> > More information in the official manual at:
> > http://conntrack-tools.netfilter.org/manual.html
> > 
> > See ChangeLog that comes attached to this email for more details.
> > 
> > You can download it from:
> > 
> > http://www.netfilter.org/projects/nfacct/downloads.html
> > ftp://ftp.netfilter.org/pub/nfacct/
> > 
> > Have fun!
> 
> Hi.
> There's a little snafu at the moment, it won't build with the current
> release version of libnetfilter_conntrack:
> 
> ******
> conntrack.c: In function 'main':
> conntrack.c:2005:10: error: 'IPCTNL_MSG_CT_GET_DYING' undeclared (first
> use in this function)
> conntrack.c:2005:10: note: each undeclared identifier is reported only
> once for each function it appears in
> conntrack.c:2015:10: error: 'IPCTNL_MSG_CT_GET_UNCONFIRMED' undeclared
> (first use in this function)
> ******

My fault, sorry.

> Fixed by http://patchwork.ozlabs.org/patch/202813/ but there's no new
> release with the patch applied yet.
> Maybe patch configure.ac to check for the new version when it's released?

I'll release libnetfilter_conntrack to fix this asap.
