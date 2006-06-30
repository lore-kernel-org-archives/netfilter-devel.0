From: Giacomo <delleceste@gmail.com>
Subject: Question about a locking problem
Date: Fri, 30 Jun 2006 09:08:15 +0200
Message-ID: <885896af0606300008h341cd400mf66700400bba28e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter devel" <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Good morning.

Some time ago i wrote a module in kernel space which does some filtering.

While running `dhclient eth0'  and plugging/unplugging the ethernet cable
from the network card, kernel freezed saying the culprit was the following
function (EIP is at get_ifaddr_by_name() ) :

/* returns in *addr the internet address having the name ifname */
int get_ifaddr_by_name(const char *ifname, __u32 * addr)
{
	struct net_device *pnet_device;
	struct in_device *pin_device;

	read_lock_bh(&dev_base_lock);
	pnet_device = dev_base;
	while (pnet_device != NULL)
	  {
		  if ((netif_running(pnet_device))
		      && (pnet_device->ip_ptr != NULL)
		      && (strcmp(pnet_device->name, ifname) == 0))
		    {
			    pin_device =
				(struct in_device *) pnet_device->ip_ptr;
			    /* ifa_local: ifa_address is the remote point in ppp */
			    *addr = (pin_device->ifa_list->ifa_local);
			    read_unlock_bh(&dev_base_lock);
			    return 1;
		    }
		 pnet_device = pnet_device->next;
	  }
	  read_unlock_bh(&dev_base_lock);
	return -1;		/* address not found! */
}

What could be wrong?
I think the problem is that read_lock_bh is not correct, perhaps
i would need read_lock_irq instead??

Can anyone suggest if i am right.

Thanks a lot

Giacomo.


-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

Proteggi il tuo PC provando il mio semplice FIREWALL:
http://www.giacomos.it/ipfire

mailto:
delleceste@gmail.com
giacomo.strangolino@elettra.trieste.it
jacum@libero.it

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
