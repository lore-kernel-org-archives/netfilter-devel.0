From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 11 Oct 2007 06:04:39 +0200
Message-ID: <470DA0D7.10803@trash.net>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl> <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46829 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbXJKEEo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 00:04:44 -0400
In-Reply-To: <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:
> With your description I could reproduce the bug and actually you were 
> completely right: the code above is incorrect. Somehow I was able to 
> misread RFC1122 and mixed the roles :-(:
> 
>    When a connection is >>closed actively<<, it MUST linger in
>    TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
>    However, it MAY >>accept<< a new SYN from the remote TCP to
>    reopen the connection directly from TIME-WAIT state, if it:
>    [...]
> 
> The fix is as follows: if the receiver initiated an active close, then the 
> sender may reopen the connection - otherwise try to figure out if we hold 
> a dead connection.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>


Applied, thanks Jozsef. I'll push this to -stable once it hits upstream.
