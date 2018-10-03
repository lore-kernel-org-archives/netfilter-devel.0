From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Wed, 3 Oct 2018 02:26:05 -0700
Message-ID: <CANP3RGdRD5cQGRthBSx0HDVesf7aSBj0gxBwGxvuXrhZfKfYmw@mail.gmail.com>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com> <20181003091941.cbaceffk3uwrqwjo@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Chenbo Feng <chenbofeng.kernel@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, kernel-team@android.com,
        Lorenzo Colitti <lorenzo@google.com>,
        Chenbo Feng <fengc@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181003091941.cbaceffk3uwrqwjo@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

While on a 32-bit arch the tail pointer is 32 bits, the struct itself
contains (and has always contained) a 64-bit value 'quota' with a
forced 64-bit alignment which forces 64-bit alignment of the entire
struct and thus also forces tail padding to make it a multiple of
64-bits.  ie. size doesn't change - even on 32 bits.

Chenbo was testing compatibility on both 32 and 64 bit x86 VMs.
