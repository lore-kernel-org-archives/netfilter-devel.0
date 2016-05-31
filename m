From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH -v3 8/8] locking, tile: Provide TILE specific
 smp_acquire__after_ctrl_dep
Date: Tue, 31 May 2016 11:32:01 -0400
Message-ID: <dde0ba6f-be60-17f6-c01d-fc6ff983840a@mellanox.com>
References: <20160531094134.606249808@infradead.org>
 <20160531094844.342792251@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <boqun.feng@gmail.com>, <Waiman.Long@hpe.com>, <tj@kernel.org>,
	<pablo@netfilter.org>, <kaber@trash.net>, <davem@davemloft.net>,
	<oleg@redhat.com>, <netfilter-devel@vger.kernel.org>,
	<sasha.levin@oracle.com>, <hofrat@osadl.org>
To: Peter Zijlstra <peterz@infradead.org>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<manfred@colorfullife.com>, <dave@stgolabs.net>,
	<paulmck@linux.vnet.ibm.com>, <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160531094844.342792251@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 5/31/2016 5:41 AM, Peter Zijlstra wrote:
> Since TILE doesn't do read speculation, its control dependencies also
> guarantee LOAD->LOAD order and we don't need the additional RMB
> otherwise required to provide ACQUIRE semantics.
>
> Cc: Chris Metcalf<cmetcalf@mellanox.com>
> Signed-off-by: Peter Zijlstra (Intel)<peterz@infradead.org>
> ---
>   arch/tile/include/asm/barrier.h |    7 +++++++
>   1 file changed, 7 insertions(+)

Looks good.

Acked-by: Chris Metcalf <cmetcalf@mellanox.com>

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
