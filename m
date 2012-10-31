From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH next] netfilter: ipv6: add getsockopt to retrieve origdst
Date: Thu, 01 Nov 2012 01:28:35 +1300
Message-ID: <50911973.2010301@treenet.co.nz>
References: <1351595329-13081-1-git-send-email-fw@strlen.de> <1351649498.10780.6947.camel@nbnickhq4> <20121031084815.GA29966@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:57649
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2JaMjT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:39:19 -0400
In-Reply-To: <20121031084815.GA29966@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/10/2012 9:48 p.m., Florian Westphal wrote:
> Nick Jones <nick.jones@network-box.com> wrote:
>>> getsockopt(m_sock, SOL_IP, SO_ORIGINAL_DST, &m_server_addr, &addrsize)
>>>
>>> but for ipv6 no such option existed.
>>>
>>> This adds getsockopt(..., IPPROTO_IPV6, IP6T_SO_ORIGINAL_DST, ...).
>>>
>>> Without this, userspace needs to parse /proc or use ctnetlink, which
>>> appears to be overkill.
>> Doesn't getsockname(2) provide this information?
> No.  It will show the local address (the address we REDIRECT'ed to).


 From the user perspective I don't see why a new code macro is 
necessary. Surely it would be sufficient to support:

   getsockopt(..., IPPROTO_IPV6, SO_ORIGINAL_DST, ...).


AYJ
