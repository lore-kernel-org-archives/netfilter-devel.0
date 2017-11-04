From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Net: netfilter: vmalloc/vfree to kvmalloc/kvfree
Date: Sat, 4 Nov 2017 01:19:00 +0100
Message-ID: <20171104001900.GI9424@breakpoint.cc>
References: <20171103200731.6576-1-chucks.8090@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Charlie Sale <chucks.8090@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171103200731.6576-1-chucks.8090@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Charlie Sale <chucks.8090@gmail.com> wrote:
> +	hinfo = kvmalloc(sizeof(*hinfo) + sizeof(struct hlist_head) * size,
> +			 GPT_KERNEL);

Looks like you did not even compile test this.  Again. :-(
