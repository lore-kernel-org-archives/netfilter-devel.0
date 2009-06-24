From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: conntrack segfault (was: Re: null-pointer deref in ulogd2)
Date: Wed, 24 Jun 2009 13:17:26 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0906241315240.2240@bizon.gios.gov.pl>
References: <h1q05h$o8h$1@ger.gmane.org> <h1q3tu$2vi$1@ger.gmane.org> <4A40F777.7010505@netfilter.org> <4A4108D6.901@birkenwald.de> <4A4159BE.7040807@birkenwald.de> <20090624105915.GA8675@schleppi.birkenwald.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-238453024-1245842246=:2240"
Cc: netfilter-devel@vger.kernel.org
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:52696 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbZFXLuS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:50:18 -0400
In-Reply-To: <20090624105915.GA8675@schleppi.birkenwald.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-238453024-1245842246=:2240
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Wed, 24 Jun 2009, Bernhard Schmidt wrote:

> On Wed, Jun 24, 2009 at 12:39:58AM +0200, Bernhard Schmidt wrote:
>
> Hi,
>
>> Oh, and we're dumping conntrack -L every minute. Works fine during the
>> day with 30k connections, but starts to frequently segfault with 60k
>> connections in the evening. Also trying to get a coredump now.
>
> sorry, this is slightly off-topic, but I can't decode the core dump :-(
>
> Jun 24 12:03:01 secomat2 kernel: conntrack[14117]: segfault at
> 7fff1ce83f34 ip 00007fff1ce83f34 sp 00007fff1ce82f20 error 15

I think you should rather try using valgrind. It is very hard to trace 
memory corruption problem with gdb.

Best regards,

 				Krzysztof Olêdzki
---1144830174-238453024-1245842246=:2240--
