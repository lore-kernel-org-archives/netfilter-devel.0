From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Thu, 09 Jun 2011 14:56:02 +0200
Message-ID: <4DF0C2E2.5050807@trash.net>
References: <4DEDEB99.4070601@netfilter.org>	<4DEFC6C9.5030004@googlemail.com>	<BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>	<201106081528.22926.sgrubb@redhat.com>	<BANLkTik9wXe+g4EXByUt3MrxGhuLKgTV3A@mail.gmail.com>	<4DF0BC5F.5040100@trash.net> <BANLkTin-M-60LSTbvAdpzfio0suYj2WcqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Steve Grubb <sgrubb@redhat.com>,
	Mr Dash Four <mr.dash.four@googlemail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-audit@redhat.com, Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Paris <eparis@parisplace.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38557 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab1FIM4F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:56:05 -0400
In-Reply-To: <BANLkTin-M-60LSTbvAdpzfio0suYj2WcqA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.06.2011 14:52, Eric Paris wrote:
> On Thu, Jun 9, 2011 at 8:28 AM, Patrick McHardy <kaber@trash.net> wrote:
>> Just to make sure, so the conclusion is that the patch is fine as
>> it is and anything related to unconvertible secids will be handled
>> by SELinux internally?
>>
> 
> No.  This patch does not get my ACK.  Steve is right that silently
> dropping information is a big big no no for the audit system and
> that's what this patch does.  This cannot be wholly handled properly
> inside the LSM either.  I don't see any patch meeting everyone's
> requirements outside of a new one that includes the audit helper I
> suggested.

OK, I see, thanks.
