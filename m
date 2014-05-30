From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH RFC v3 0/2] per-netns sysctl for br_netfilter
Date: Fri, 30 May 2014 14:04:54 +0400
Message-ID: <538857C6.7070602@parallels.com>
References: <20140512140706.GA22082@macbook.localnet> <5370F772.3050004@parallels.com> <20140529122859.GA5412@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	=?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:2893 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbaE3KFU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2014 06:05:20 -0400
In-Reply-To: <20140529122859.GA5412@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/29/2014 04:28 PM, Pablo Neira Ayuso wrote:
> Hi Vasily,
> 
> On Mon, May 12, 2014 at 08:31:46PM +0400, Vasily Averin wrote:
>> This patch set enables per network namespace managemnt for br_netfiltes sysctls,
>> it allows to enable processing br-nf-call hooks in ones network namespaces 
>> and keep it disabled in another ones.
>>
>> v3: patches are merged into more large chunks 
>> v2: removed extra overhead for CONFIG_SYSCTL=n
> 
> Any further concern with this v3 patchset? Thanks.

Dear Pablo,
I'm going to re-make this patchset to add ability to inherit settings from new parent's net-namespace.
Unfortunately right now I'm quite busy by relocation, therefore this task is delayed.
Also I would like say thanks to Bart and Maciej Zenczykowski for feedback.
