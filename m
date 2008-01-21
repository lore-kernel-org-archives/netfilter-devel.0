From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 14:23:25 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801211417200.24186@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr>
 <479461C2.1060703@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47871 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbYAUNX0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:23:26 -0500
In-Reply-To: <479461C2.1060703@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On January 21 2008 10:11, Laszlo Attila Toth wrote:
>Jan Engelhardt wrote:
>> I just remembered that xt_socket (from tproxy) does an (explicit) socket
>> lookup. xt_owner on the other hand, takes the socket pointer from the skb --
>> which of course only works in the output path.
>> 
>> xt_owner is still in the 2.6.25 development queue, and because the two
>> modules are similar, I thought that maybe xt_owner could be merged with
>> xt_socket (doing a rename to xt_socket in the current net-2.6.25),
>> because they are quite close in their task.
>> 
>> That would also allow xt_owner to be used in the input path.
>> 
>> Opinions?
>
> Hello,
>
> That sounds great.
>
> Note that the socket match depends on tproxy core, also the tproxy would be
> partially merged into the net-2.25 tree. [...]

Here is what I had in mind, please have a look.
http://dev.computergmbh.de/gitweb.cgi?p=linux;h=dev-xtsocket;a=shortlog
