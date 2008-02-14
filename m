From: Giacomo <delleceste@gmail.com>
Subject: get internet v6 address from interface name
Date: Thu, 14 Feb 2008 13:55:26 +0000
Message-ID: <885896af0802140555u3cfd8e51hf81fda5159cac5f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:1035 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYBNNz1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:55:27 -0500
Received: by wa-out-1112.google.com with SMTP id v27so597312wah.23
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Feb 2008 05:55:27 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning, can anyone give me a hint for this problem?

I have written a kernel module.

I would need to know how to retrieve the ipv6 address structure
knowing the network interface name.

For ipv4, i do as follows:

int get_ifaddr_by_name(const char *ifname, __u32 * addr)
{
       struct net_device *pnet_device;
       struct in_device *pin_device;
       struct in_ifaddr* inet_ifaddr;

       read_lock_bh(&dev_base_lock);

       pnet_device = first_net_device();
       while (pnet_device != NULL)
       {
               if ((netif_running(pnet_device))
                               && (pnet_device->ip_ptr != NULL)
                               && (strcmp(pnet_device->name, ifname) == 0))
               {
                       pin_device =
                               (struct in_device *) pnet_device->ip_ptr;
                       inet_ifaddr = pin_device->ifa_list;
                       if(inet_ifaddr == NULL)
                       {
                               printk("ifa_list is null!\n");
                               break;
                       }
                       /* ifa_local: ifa_address is the remote point in ppp */
                       *addr = (inet_ifaddr->ifa_local);
                       read_unlock_bh(&dev_base_lock);
                       return 1;
               }
               pnet_device = next_net_device(pnet_device);
       }

       read_unlock_bh(&dev_base_lock);
       return -1;              /* address not found! */
}

thanks for any suggestion/hint/example

giacomo.

-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

IPFIREwall (http://www.giacomos.it/ipfire) viene presentato
all'Universita` degli Studi di Udine, il 28 ottobre, in occasione del
Linux Day 2006:
http://iglu.cc.uniud.it/linuxday

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
