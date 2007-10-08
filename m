From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Mon, 08 Oct 2007 18:39:08 +0200
Message-ID: <470A5D2C.1040006@trash.net>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net> <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu> <47049D5B.8050001@trash.net> <Pine.LNX.4.64.0710041018180.1677@blackhole.kfki.hu> <Pine.LNX.4.64.0710052151180.11803@bizon.gios.gov.pl> <Pine.LNX.4.64.0710081117270.6987@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34315 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXJHQll (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 12:41:41 -0400
In-Reply-To: <Pine.LNX.4.64.0710081117270.6987@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:
> Hi Krzysztof,
> 
>>--- example #1 begin ---
> 
> [...]
> 
> The last sequence number ACK-ed by the server is 3235585701. The ISN sent 
> by the client at reopening is 2494249856, which is not after the largest
> sequence number used in the previous session.
> 
> 
>>--- example #1 begin ---
> 
> [...]
> 
> 
> And the same here: largest seq is 3536556183, but the ISN is 3521103209.
> 
> It seems to me conntack is just right.


thats true, but I'm wondering, is there any benefit in being
strict about this? The chances of accidentally reopening an
old connection are a lot smaller than breaking things as in
this case. Or maybe we could add PAWS checks, although that
would increase the conntrack size by another 8 bytes.

Krzysztof, does the problem disappear if you use something
like 30 s for the TIME_WAIT timeout?
