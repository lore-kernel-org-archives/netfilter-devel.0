From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Tue, 07 Jun 2011 01:22:43 +0200
Message-ID: <4DED6143.1050809@netfilter.org>
References: <4DDE9194.4030303@netfilter.org> <201106060830.52644.sgrubb@redhat.com> <4DECCB27.6040706@googlemail.com> <201106060853.57940.sgrubb@redhat.com> <4DECD1D8.60804@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
	netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56673 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1FFXWw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:22:52 -0400
In-Reply-To: <4DECD1D8.60804@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/06/11 15:10, Mr Dash Four wrote:
> 
>> Exactly my point. There is no leak if its text or numeric.
>>   
> No, there is no leak if it is a text, but there *is* a leak if it is a
> numeric. I think I've made that quite clear.

We don't use numeric secmark anymore in nf_conntrack. Not very familiar
with SELinux, but I remember that the convention was not to provide
internal numeric values.
