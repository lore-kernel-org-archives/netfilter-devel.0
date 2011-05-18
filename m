From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/9] libxt_udp: use guided option parser
Date: Wed, 18 May 2011 15:58:40 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105181546160.25276@frira.zrqbmnf.qr>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de> <1304250630-6150-9-git-send-email-jengelh@medozas.de> <20110518124916.GA12964@lutz.bln.innominate.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51754 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824Ab1ERN6l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 09:58:41 -0400
In-Reply-To: <20110518124916.GA12964@lutz.bln.innominate.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2011-05-18 14:49, Lutz Jaenicke wrote:
>
>this modification lead to a subtle failure I don't know how to cure yet.
>
>> +	{.name = "dport", .id = O_DEST_PORT, .type = XTTYPE_PORTRC_NE,
>> +	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
>> +	XTOPT_TABLEEND,
>>  };
>
>The port parsing now performed indirectly via xtables_getportbyname() and
>then hence getaddrinfo().
>At least for uClibc (did not test glibc), getaddrinfo() will complain
>when a port is specified by number but no socket type of address family
>is set:
>...
>  /*
>   * Can't specify a numerical socket unless a protocol
>   * family was given.
>   */
>   if (hints->ai_socktype == 0 && hints->ai_protocol == 0)
>            return EAI_SERVICE;
>...

That's one of these totally useless comments. I know from the
condition that it disallows them, but it fails to say _why_, and what
makes numerical specs different from name-based ones - in particular
they should ask themselves, why should getaddrinfo special-case it
when getportbyfoo does not?

>The straight forward solution would be to add a respective ai_protocol
>information (we actually know that it is IPPROTO_UDP). I am currently
>however not deep enough into the new parser structure to know where to
>add this information to the function calls and or data structures.

The approach would be to encode the family in xt_option_entry somehow. 
Possilibites are a new XTTYPE_UDPPORT (suboptimal because all protos 
would need to be specified), or seemingly better, a flag that would 
interpret the .max field as a family instead (similar to how 
XTTYPE_TOSMASK uses it). Me ponders.
