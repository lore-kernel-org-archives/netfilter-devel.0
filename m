From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Get the IP address of an interface with a given name
Date: Mon, 19 Nov 2007 15:34:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711191531340.32378@fbirervta.pbzchgretzou.qr>
References: <885896af0711190557l682e784ye186491c13affa35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38153 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbXKSOee (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:34:34 -0500
In-Reply-To: <885896af0711190557l682e784ye186491c13affa35@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 19 2007 14:57, Giacomo wrote:
>
> I have written a kernel function which needs to get the IP address
> of an active network interface given its name.

And why is that?

If you are trying to write a netfilter module, just use the 'in' or
'out' parameters.
If not, try posting to netdev@vger.kernel.org instead.

> The actual implementation i have done is like this
> but i suspect this does not always work.
> Is there any API already provided by the kernel to do the same?
>
> -- actual implementation: ---
>
> /* returns in *addr the internet address having the name ifname */
> int get_ifaddr_by_name(const char *ifname, __u32 * addr)

Problematic: Does not handle anything besides IPv4.

> {
>         struct net_device *pnet_device;
>         struct in_device *pin_device;
>         struct in_ifaddr* inet_ifaddr;
>
>         read_lock_bh(&dev_base_lock);
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
>         pnet_device = dev_base;
> #else
>         pnet_device = first_net_device();
> #endif

There is for_each_netdev().

>         while (pnet_device != NULL)
>         {
>                 if ((netif_running(pnet_device))
>                                 && (pnet_device->ip_ptr != NULL)
>                                 && (strcmp(pnet_device->name, ifname) == 0))
>                 {
>                         pin_device =
>                                 (struct in_device *) pnet_device->ip_ptr;
>                         inet_ifaddr = pin_device->ifa_list;
>                         if(inet_ifaddr == NULL)
>                         {
>                                 printk("ifa_list is null!\n");
>                                 break;
>                         }
>                         /* ifa_local: ifa_address is the remote point in ppp */
>                         *addr = (inet_ifaddr->ifa_local);
>                           read_unlock_bh(&dev_base_lock);
>                         return 1;
>                 }
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
>                 pnet_device = pnet_device->next;
> #else
>                 pnet_device = next_net_device(pnet_device);
> #endif
>
>         }
>
>         read_unlock_bh(&dev_base_lock);
>         return -1;              /* address not found! */
> }
