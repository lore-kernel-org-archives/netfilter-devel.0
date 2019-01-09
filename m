From: wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH] nft_flow_offload: Make flow offload work with vrf slave
 device correct
Date: Wed, 9 Jan 2019 10:52:04 +0800
Message-ID: <0cbf054a-6948-0b36-19d2-5eff27b2dbd6@ucloud.cn>
References: <1546078225-22699-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1546078225-22699-1-git-send-email-wenxu@ucloud.cn>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi pablo,

How about the status for this patch?
 

On 12/29/2018 6:10 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> In the forward chain the iif is changed from slave device to master vrf
> device. It will lead the offload not match on lower slave device.
>
> This patch make the flollowing example can work correct
>
>
