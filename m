From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC 0/4] nfnetlink_queue bypass queue to userspace X bytes of
 connection
Date: Mon, 26 Jul 2010 19:35:24 +0200
Message-ID: <4C4DC75C.2010703@netfilter.org>
References: <1279986285-11665-1-git-send-email-karl@hiramoto.org> <4C4B305F.2070005@netfilter.org> <4C4BDFEC.4080600@hiramoto.org> <4C4C1524.8070805@netfilter.org> <4C4D2C33.6050901@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43996 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab0GZRfr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jul 2010 13:35:47 -0400
In-Reply-To: <4C4D2C33.6050901@hiramoto.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26/07/10 08:33, Karl Hiramoto wrote:
>  On 25/07/2010 12:42, Pablo Neira Ayuso wrote:
>>
>> You can limit the string matching for only a few bytes in the very
>> beginning of the packet. 
> That really doesn't help trying to find the "Host:" or path of or URL in
> HTTP because you don't know variables like cookie length, or other
> variables. String match also doesn't help me at all if the string is
> split across multiple packets

We can look for some string (in a limited range of bytes) that
preliminarily identifies some sort of traffic in kernel-space. In case
of matching, we pass the packet (or some short part of it) to user-space
via NFQUEUE. The whole specific packet parsing (such as looking at the
Host tokens of HTTP/1.1 that you refer) is done in user-space.

>> This extension seems to me very specific for HTTP/1.1.
> HTTP is the most popular protocol on the internet[1][2][3], optimizing
> the most common case has merits.
> 
> Besides HTTP  I can imagine this extension helping implementing a POP3
> or IMAP filter using NF_QUEUE.   For example many network UTM devices
> that scan attachments for viruses or other blocked content, will skip a
> compressed file that is over X bytes because there is not enough free
> memory to decompress and scan it.   In this case you could bypass the
> queue for X bytes, then continue scanning smaller files.

Making assumptions on the Content-Length and any other information in
the packet seems wrong to me. Someone could forge a packet to by-pass
filtering.
