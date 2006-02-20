From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] iptables 32bit compat layer
Date: Mon, 20 Feb 2006 00:31:46 -0800 (PST)
Message-ID: <20060220.003146.93580812.davem@davemloft.net>
References: <200602201110.39092.dim@openvz.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	rusty@rustcorp.com.au, akpm@osdl.org, devel@openvz.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932287AbWBTIbl@vger.kernel.org>
To: dim@openvz.org
In-Reply-To: <200602201110.39092.dim@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Mishin Dmitry <dim@openvz.org>
Date: Mon, 20 Feb 2006 11:10:38 +0300

> This patch set extends current iptables compatibility layer in order
> to get 32bit iptables to work on 64bit kernel. Current layer is
> insufficient due to alignment checks both in kernel and user space
> tools.

Thanks a lot for doing this work Mishin.
