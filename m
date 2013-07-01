From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: C++ compile errors
Date: Mon, 01 Jul 2013 23:16:09 +1200
Message-ID: <51D164F9.9030201@treenet.co.nz>
References: <51CFDFBE.6050106@treenet.co.nz> <20130630161411.GA28817@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:36938
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3GALQO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:16:14 -0400
In-Reply-To: <20130630161411.GA28817@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 1/07/2013 4:14 a.m., Pablo Neira Ayuso wrote:
> Hi Amos,
>
> On Sun, Jun 30, 2013 at 07:35:26PM +1200, Amos Jeffries wrote:
>> Can anyone update me on whether this submission or an equivalent fix
>> ever made it into the formal releases? and if so which ones?
>> https://lkml.org/lkml/2012/9/30/146
> The solution for this is to cache the modified header (that compiles
> with C++) in your application source code tree. We cannot take changes
> to get C++ application compiling, sorry.

Really? The application I'm working with is only trying to use 
getsockopt() interface with IP6T_SO_ORIGINAL_DST. Nothing more.

/usr/include/linux/netfilter_ipv6/ip6_tables.h: In function 
'xt_entry_target* ip 6t_get_target(ip6t_entry*)':
/usr/include/linux/netfilter_ipv6/ip6_tables.h:261:19: error: invalid 
conversion from 'void*' to 'xt_entry_target*' [-fpermissive]
   return (void *)e + e->target_offset;
                    ^

Restricting all users of the published headers to C-compilers is a bit 
annoying. Good way to prevent anyone using IPv6 with NAT though ;-)

Amos
