From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 5/5] nfacct: add timestamp option
Date: Sat, 01 Sep 2012 13:49:59 +0100
Message-ID: <50420477.6040705@googlemail.com>
References: <1343856436-11129-1-git-send-email-eric@regit.org> <1343856436-11129-6-git-send-email-eric@regit.org> <20120803093533.GE12107@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36555 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2IAMuE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Sep 2012 08:50:04 -0400
Received: by wibhr14 with SMTP id hr14so2549506wib.1
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Sep 2012 05:50:02 -0700 (PDT)
In-Reply-To: <20120803093533.GE12107@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Pablo Neira Ayuso wrote:
> On Wed, Aug 01, 2012 at 11:27:16PM +0200, Eric Leblond wrote:
>> This patch adds a timestamp option to the nfacct plugin.
>> If activated, nfacct output a timestamp which is computed just
>> after sending the nfacct request.
> 
> I think it makes sense to make it unconditionally.
Yep. The PGSQL output plugin can't function without it. When I have the following:

stack=acct1:NFACCT,pgsql3:PGSQL

I get the following error if timestamp is not enabled:

<7> ulogd.c:700 type mismatch between PGSQL and NFACCT in stack
<7> ulogd.c:727 cannot find key `oob.time.sec' in stack

I had to dig in further to find out why that was the case (something I could have done without), so I think it makes sense for the timestamp to always be included.
