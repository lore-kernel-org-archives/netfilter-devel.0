From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 1/6] ctnetlink: add callbacks to the per-proto nlattrs
Date: Wed, 25 Mar 2009 18:25:35 +0100
Message-ID: <49CA690F.20107@trash.net>
References: <20090316220659.756862181@jonathan.eitzenberger.org> <20090316221135.741449312@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090316221135.741449312@jonathan.eitzenberger.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Holger Eitzenberger wrote:
> There is added a single callback for the l3 proto helper.  The two
> callbacks for the l4 protos are necessary because of the general
> structure of a ctnetlink event, which is in short:
> 
>  CTA_TUPLE_ORIG
>    <l3/l4-proto-attributes>
>  CTA_TUPLE_REPLY
>    <l3/l4-proto-attributes>
>  CTA_ID
>  ...
>  CTA_PROTOINFO
>    <l4-proto-attributes>
>  CTA_TUPLE_MASTER
>    <l3/l4-proto-attributes>
> 
> Therefore the formular is
> 
>  size := sizeof(generic-nlas) + 3 * sizeof(tuple_nlas) + sizeof(protoinfo_nlas)
> 
> Some of the NLAs are optional, e. g. CTA_TUPLE_MASTER, which is only
> set if it's an expected connection.  But the number of optional NLAs is
> small enough to prevent netlink_trim() from reallocating if calculated
> properly.

Applied, thanks.
