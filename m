From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 2/6] netlink: add nla_policy_len()
Date: Wed, 25 Mar 2009 18:27:31 +0100
Message-ID: <49CA6983.6050304@trash.net>
References: <20090316220659.756862181@jonathan.eitzenberger.org> <20090316221137.034320718@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090316221137.034320718@jonathan.eitzenberger.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Holger Eitzenberger wrote:
> It calculates the max. length of a Netlink policy, which is usefull
> for allocating Netlink buffers roughly the size of the actual
> message.

Applied, thanks.
