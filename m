From: Giacomo <delleceste@gmail.com>
Subject: Get the IP address of an interface with a given name
Date: Mon, 19 Nov 2007 14:57:33 +0100
Message-ID: <885896af0711190557l682e784ye186491c13affa35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:28996 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbXKSN5e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:57:34 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1975352wah
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Nov 2007 05:57:34 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Good morning.

 I have written a kernel function which needs to get the IP address of
an active network interface
 given its name.

 The actual implementation i have done is like this
 but i suspect this does not always work.
 Is there any API already provided by the kernel to do the same?

 Thanks a lot

 Giacomo

 -- actual implementation: ---

 /* returns in *addr the internet address having the name ifname */
 int get_ifaddr_by_name(const char *ifname, __u32 * addr)
 {
         struct net_device *pnet_device;
         struct in_device *pin_device;
         struct in_ifaddr* inet_ifaddr;

         read_lock_bh(&dev_base_lock);
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
         pnet_device = dev_base;
 #else
         pnet_device = first_net_device();
 #endif
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
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
                 pnet_device = pnet_device->next;
 #else
                 pnet_device = next_net_device(pnet_device);
 #endif

         }

         read_unlock_bh(&dev_base_lock);
         return -1;              /* address not found! */
 }

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
