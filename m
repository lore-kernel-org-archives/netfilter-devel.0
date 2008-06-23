From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 09/25] netns ct: get proper netns from netdevice
Date: Mon, 23 Jun 2008 12:35:00 +0200
Message-ID: <485F7C54.5070506@trash.net>
References: <20080622010821.GJ5392@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	den@openvz.org, xemul@openvz.org, ebiederm@xmission.com,
	benjamin.thery@bull.net, dlezcano@fr.ibm.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20080622010821.GJ5392@martell.zuzino.mipt.ru>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexey Dobriyan wrote:
> Get netns from skb->dev on input, from skb->dst->dev on output to know
> where to create or search for conntrack.
> 
> Is there some documentation re which device accessible from skb is valid
> at which point?

For netfilter hooks, skb->dev points to the input device in
PREROUTING, INPUT, FORWARD, to the output device in POSTROUTING
and is invalid in OUTPUT.

> @@ -626,10 +628,14 @@ resolve_normal_ct(struct sk_buff *skb,
>  		return NULL;
>  	}
>  
> +	dev = skb->dev;
> +	if (!dev)
> +		dev = skb->dst->dev;
> +	net = dev_net(dev);

Maybe just pass it though nf_conntrack_in from the hook functions,
those get the devices as arguments.
