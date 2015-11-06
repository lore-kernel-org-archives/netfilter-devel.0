From: Ani Sinha <ani@arista.com>
Subject: Re: [PATCH -stable,3.4.y] netfilter: nf_conntrack: fix RCU race in nf_conntrack_find_get
Date: Fri, 6 Nov 2015 14:27:07 -0800
Message-ID: <CAOxq_8PtAuK+sRd_PSoxZajCT2mncFkS1B-OisAUMaLz4aS8DA@mail.gmail.com>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <1446813886-5632-3-git-send-email-pablo@netfilter.org> <20151106170946.GD24185@kroah.com>
 <20151106172743.GC1357@salvia> <CAOxq_8Ptkm2EPm2Y8Nfd7sQdsh1Yq5KFdgcyq1REmr9WsCx+4w@mail.gmail.com>
 <20151106221126.GA19582@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Zefan Li <lizefan@huawei.com>, netfilter-devel@vger.kernel.org,
	stable <stable@vger.kernel.org>,
	Andrey Vagin <avagin@openvz.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Cyrill Gorcunov <gorcunov@openvz.org>
To: Greg KH <greg@kroah.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20151106221126.GA19582@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Nov 6, 2015 at 2:11 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 06, 2015 at 12:30:55PM -0800, Ani Sinha wrote:
>> I am not sure how you guys work but I think this two patches needs to
>> be applied here :
>>
>> https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y-queue.git/
>
> I have no idea what you are referring to here :(

The patches which we are referring to here is only for linux 3.4
series. The testing was only done on 3.4 not on other -stable
releases. I don't even know if the patch would cleanly apply on other
stable trains. Since I see Zefan maintains 3.4 and he has a linux git
queue, I thought may be these patches should be applied there. That is
what I was wondering. I don't have clear understanding how Zefan pulls
his 3.4 backport patches from.

Does that make sense?
