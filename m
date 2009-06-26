From: Philip Craig <philipc@snapgear.com>
Subject: Re: conntrack untracked match is broken (kernel patch)
Date: Fri, 26 Jun 2009 17:45:25 +1000
Message-ID: <4A447C95.7000309@snapgear.com>
References: <4A3F2547.30301@snapgear.com> <alpine.LSU.2.00.0906251841140.23831@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:43761 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752004AbZFZHpX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:45:23 -0400
In-Reply-To: <alpine.LSU.2.00.0906251841140.23831@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-06-22 08:31, Philip Craig wrote:
>> Looks like we need a conntrack match v2 to fix this?
> 
> 
> Here is the kernel patch, please apply. Userspace as a reply.

Thank you, works fine with both patches applied.  I didn't
test old/new combinations.
