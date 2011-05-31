From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Possible iptables 4.4.11 issues
Date: Tue, 31 May 2011 11:42:06 +0200
Message-ID: <4DE4B7EE.9060107@netfilter.org>
References: <4DE2593E.7000208@shorewall.net> <alpine.LNX.2.01.1105291647200.26223@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tom Eastep <teastep@shorewall.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Steven Jan Springl <steven@springl.ukfsn.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40733 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1EaJmq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 05:42:46 -0400
In-Reply-To: <alpine.LNX.2.01.1105291647200.26223@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29/05/11 16:48, Jan Engelhardt wrote:
> 
> On Sunday 2011-05-29 16:33, Tom Eastep wrote:
>> After upgrading iptables to 1.4.11 the following iptables-restore error
>> is produced:
>>
>> iptables-restore v1.4.11: owner: option "--uid-owner" cannot be inverted.
> 
> Bug, fix will be submitted.
> 
>> -A OUTPUT -p 6 --dport 888 -o eth1 -j IPMARK --addr
>> dst --and-mask -1 --or-mask -64 --shift 0
>> After upgrading to iptables 1.4.11 the following iptables-restore error is
>> produced:
>>
>> iptables-restore v1.4.11: IPMARK: Bad value for "and-mask" option: "-1"
> 
> This is intentional. Bitwise operations work best when fed unsigned numbers
> only.

but this used to work, we shouldn't break this sort of things Jan.
