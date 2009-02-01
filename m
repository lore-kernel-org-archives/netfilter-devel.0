From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libxtables: prefix names and order it #1
Date: Sun, 01 Feb 2009 22:17:59 +0100
Message-ID: <49861187.3020708@netfilter.org>
References: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr>  <1233065970.13279.74.camel@dogo.mojatatu.com> <1233066572.13279.76.camel@dogo.mojatatu.com> <alpine.LSU.2.00.0901300550390.23947@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jamal <hadi@cyberus.ca>, kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56148 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751395AbZBAVSL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Feb 2009 16:18:11 -0500
In-Reply-To: <alpine.LSU.2.00.0901300550390.23947@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-01-27 15:29, jamal wrote:
>> On Tue, 2009-01-27 at 09:19 -0500, jamal wrote:
>>
>>> Ok, no problem - let me know when you are done.
>> BTW, it would be nice if you commit those patches to the git tree and i
>> pull them.
> 
> The proposed changes are at
> 
> 	git://dev.medozas.de/iptables master
> 
> 	92 files changed, 1063 insertions(+), 1135 deletions(-)
> 
> They are pretty broad, but repetitive.
> 
> There are a few functions left. Like exit_error, which still has ties
> to the origin program (iptables, ip6tables), to do option freeing for
> example. Have not yet thought of how to resolve that. Ideas welcome.

I think that you can move functions that are common to iptables and
ip6tables like exit_error(), merge_options(), ... and so on to
libxtables. I think that the purpose of this libxtables library should be:

1) To provide an API for jamal's tc ipt and your xtables-addon thing
(anyone willing to compile their .so files without recompiling iptables).
2) To factorize some code which is common to iptables and ip6tables.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
