From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables issue in compat mode
Date: Sun, 04 May 2014 23:04:32 +0200
Message-ID: <5366AB60.7020009@pandora.be>
References: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>	<20140501100229.GS31953@breakpoint.cc> <CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Sharat Masetty <sharat04@gmail.com>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:33117 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaEDVEk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 17:04:40 -0400
In-Reply-To: <CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sharat Masetty schreef op 1/05/2014 18:09:
> We are using a 3.10.0 kernel version which has CONFIG_COMPAT enabled.
> The ebtables version is 2.0.10-4.  This is arm 63/32 not x86.
> I also have another question. Do we need to compile the userspace tool
> using the sanitized kernel headers?(uapi/linux) or should we be using
> headers provided in the ebtables user space package? The reason for
> asking this question is that I see some differences in the structure
> definitions between the ebtables packaged kernel header files and the
> header files exposed by the kernel.

The kernel should be backwards compatible, so using the provided header 
files should be fine.

cheers,
Bart

