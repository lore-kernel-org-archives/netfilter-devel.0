From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Mon, 6 Jun 2011 20:59:03 -0400
Message-ID: <201106062059.03876.sgrubb@redhat.com>
References: <4DDE9194.4030303@netfilter.org> <4DECD1D8.60804@googlemail.com> <4DED6143.1050809@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>, linux-audit@redhat.com,
	netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1FGA7W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 20:59:22 -0400
In-Reply-To: <4DED6143.1050809@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday, June 06, 2011 07:22:43 PM Pablo Neira Ayuso wrote:
> On 06/06/11 15:10, Mr Dash Four wrote:
> >> Exactly my point. There is no leak if its text or numeric.
> > 
> > No, there is no leak if it is a text, but there *is* a leak if it is a
> > numeric. I think I've made that quite clear.
> 
> We don't use numeric secmark anymore in nf_conntrack. Not very familiar
> with SELinux, but I remember that the convention was not to provide
> internal numeric values.

All of the audit system records the numbers if conversion fails. We want it as 
forensic evidence or troubleshooting information as the case may be.

-Steve
