From: Ani Sinha <ani@arista.com>
Subject: Re: [PATCH -stable,3.4.y] netfilter: nf_conntrack: fix RCU race in nf_conntrack_find_get
Date: Fri, 6 Nov 2015 12:30:55 -0800
Message-ID: <CAOxq_8Ptkm2EPm2Y8Nfd7sQdsh1Yq5KFdgcyq1REmr9WsCx+4w@mail.gmail.com>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <1446813886-5632-3-git-send-email-pablo@netfilter.org> <20151106170946.GD24185@kroah.com>
 <20151106172743.GC1357@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Greg KH <greg@kroah.com>, netfilter-devel@vger.kernel.org,
	stable <stable@vger.kernel.org>,
	Andrey Vagin <avagin@openvz.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Cyrill Gorcunov <gorcunov@openvz.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Zefan Li <lizefan@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36386 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032899AbbKFUbP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 15:31:15 -0500
Received: by igdg1 with SMTP id g1so46104028igd.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2015 12:31:15 -0800 (PST)
In-Reply-To: <20151106172743.GC1357@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am not sure how you guys work but I think this two patches needs to
be applied here :

https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y-queue.git/



On Fri, Nov 6, 2015 at 9:27 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Nov 06, 2015 at 09:09:46AM -0800, Greg KH wrote:
>> On Fri, Nov 06, 2015 at 01:44:45PM +0100, Pablo Neira Ayuso wrote:
>> > From: Andrey Vagin <avagin@openvz.org>
>> >
>> > [ upstream commit 6aec24dfd7548dba0134f60f28f58580f07c540b ]
>>
>> Also not valid :(
>
> This one you're right:
>
> This should be c6825c0976fa7893692e0e43b09740b419b23c09 instead.
>
> Sorry.
