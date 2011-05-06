From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] netfilter: Implement RFC 1123 for FTP conntrack
Date: Fri, 06 May 2011 13:50:38 -0400
Message-ID: <4DC434EE.5050506@suse.com>
References: <4DC4322C.2020602@suse.com> <alpine.LNX.2.01.1105061943560.22432@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41392 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab1EFRun (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 May 2011 13:50:43 -0400
In-Reply-To: <alpine.LNX.2.01.1105061943560.22432@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/06/2011 01:45 PM, Jan Engelhardt wrote:
> On Friday 2011-05-06 19:38, Jeff Mahoney wrote:
> 
>> The FTP conntrack code currently only accepts the following format for
>> the 227 response for PASV:
>> 227 Entering Passive Mode (148,100,81,40,31,161).
>>
>> It doesn't accept the following format from an obscure server:
>> 227 Data transfer will passively listen to 67,218,99,134,50,144
>>
>>From RFC 1123: The format of the 227 reply to a PASV command is not 
>> well standardized.  In particular, an FTP client cannot assume that the 
>> parentheses shown on page 40 of RFC-959 will be present (and in fact, 
>> Figure 3 on page 43 omits them).  Therefore, a User-FTP program that 
>> interprets the PASV reply must scan the reply for the first digit of 
>> the host and port numbers.
>>
>> This patch adds support for the RFC 1123 clarification[...]
>>
>> Tracked in: https://bugzilla.novell.com/show_bug.cgi?id=466279
> 
> "You are not authorized to access bug #466279."

Hrm. I'm afraid I can't do anything about that. I don't have permissions
to open it up. It's mostly just clarification.

The summary is just that the second 227 response above doesn't get
properly handled without the patch and does with it. I can re-submit
without the reference if needed.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk3ENO4ACgkQLPWxlyuTD7LjrQCfcncHTbLxovQ2UqXfxJ1EiJAQ
BlUAnikJGLCGOrrzeP1ryohuovFvFT/m
=9xWX
-----END PGP SIGNATURE-----
