From: wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH] netfilter: x_tables: add xt_tunnel match
Date: Wed, 9 Jan 2019 10:48:55 +0800
Message-ID: <243c3130-e47d-134e-873a-3508473a836f@ucloud.cn>
References: <1545387144-5796-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1545387144-5796-1-git-send-email-wenxu@ucloud.cn>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi pablo,

How about the state for this patch?


On 12/21/2018 6:12 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch allows us to match on the tunnel metadata that is available
> of the packet. We can use this to validate if the packet comes from/goes
> to tunnel and the corresponding tunnel ID in the iptables.
>
>
