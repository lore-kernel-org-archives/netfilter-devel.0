From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH v2] nf_nat: no IP_NAT_RANGE_MAP_IPS flags when
	alloc_null_binding()
Date: Tue, 3 Aug 2010 06:01:33 +0800
Message-ID: <AANLkTinddDNjZv7=4mYqaKu3KrS1UJ0yJLOm5=8bbMNe@mail.gmail.com>
References: <1280673907-12619-1-git-send-email-xiaosuo@gmail.com>
	<4C56E70F.7090708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4C56E70F.7090708@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Aug 2, 2010 at 11:41 PM, Patrick McHardy <kaber@trash.net> wrote:
> On 01.08.2010 16:45, Changli Gao wrote:
>> when alloc_null_binding(), no IP_NAT_RNAGE_MAP_IPS in flags means no IP address
>> translation is needed. It isn't necessary to specify the address explicitly.
>
> When sending updated patches, you have to tell people what has changed.
>

The previous one initializes the whole structure range to 0, and this
one only initializes the field flags to 0.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
