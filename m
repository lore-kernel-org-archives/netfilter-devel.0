From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Wed, 3 Oct 2018 11:28:39 +0200
Message-ID: <20181003092839.xxl7yjg6diqxzmic@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
 <20181003091941.cbaceffk3uwrqwjo@salvia>
 <CANP3RGdRD5cQGRthBSx0HDVesf7aSBj0gxBwGxvuXrhZfKfYmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Chenbo Feng <chenbofeng.kernel@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, kernel-team@android.com,
        Lorenzo Colitti <lorenzo@google.com>,
        Chenbo Feng <fengc@google.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANP3RGdRD5cQGRthBSx0HDVesf7aSBj0gxBwGxvuXrhZfKfYmw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Oct 03, 2018 at 02:26:05AM -0700, Maciej Żenczykowski wrote:
> While on a 32-bit arch the tail pointer is 32 bits, the struct itself
> contains (and has always contained) a 64-bit value 'quota' with a
> forced 64-bit alignment which forces 64-bit alignment of the entire
> struct and thus also forces tail padding to make it a multiple of
> 64-bits.  ie. size doesn't change - even on 32 bits.
> 
> Chenbo was testing compatibility on both 32 and 64 bit x86 VMs.

Great! Hopefully this is my last question. Thanks for addressing them all.
