From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Tue, 07 Jun 2011 01:20:17 +0200
Message-ID: <4DED60B1.9080804@netfilter.org>
References: <4DDE9194.4030303@netfilter.org> <4DD5BF5A.2030108@googlemail.com> <4DDE848F.1070508@netfilter.org> <4DDE87F5.9050606@googlemail.com> <4DEA4B44.8050809@googlemail.com> <4DEC0C01.4040900@netfilter.org> <4DECC1D9.7010605@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux-audit <linux-audit@redhat.com>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56409 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1FFXUU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:20:20 -0400
In-Reply-To: <4DECC1D9.7010605@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/06/11 14:02, Mr Dash Four wrote:
> 
>> Minor nitpick. This 'if' needs one {
>>   
> Is this a style-type requirement I wasn't aware of? Because from a
> syntax point of view the left/right braces aren't necessary.

Aware of it, it's just coding style.
