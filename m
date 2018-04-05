From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 00/12] Ethernet: Add and use ether_<type>_addr globals
Date: Thu, 5 Apr 2018 16:05:51 +0200
Message-ID: <999e4ee7-2e4e-6bf9-ac76-209e259c83e4@nbd.name>
References: <cover.1522479607.git.joe@perches.com>
 <e0ab9616-64fa-cdbc-7a77-7e25d70c1a52@nbd.name>
 <1522936292.11185.15.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
To: Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522936292.11185.15.camel@perches.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2018-04-05 15:51, Joe Perches wrote:
>>  You have to factor in
>> not just the .text size, but the fact that referencing an exported
>> symbol needs a .reloc entry as well, which also eats up some space (at
>> least when the code is being built as module).
> 
> Thanks, the modules I built got smaller.
Please post some numbers to show this. By the way, on other
architectures the numbers will probably be different, especially on
ARM/MIPS.
>> In my opinion, your series probably causes more bloat in common
>> configurations instead of reducing it.
>> 
>> You're also touching several places that could easily use
>> eth_broadcast_addr and eth_zero_addr. I think making those changes would
>> be more productive than what you did in this series.
> 
> Doubtful. AFAIK: possible unaligned addresses.
Those two are just memset calls, alignment does not matter.

- Felix
