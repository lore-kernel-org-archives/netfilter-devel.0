From: Nils Radtke <Nils.Radtke@Think-Future.de>
Subject: Re: local NAT
Date: Sat, 14 Jun 2003 11:48:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030614114857.A13339@marvin.informatik.uni-stuttgart.de>
References: <20030607215013.4F9B8444E8@service.i-think-future.de> <20030611120649.GK32593@sunbeam.de.gnumonks.org> <20030611140313.GB8055@balabit.hu> <20030611145856.GT32593@sunbeam.de.gnumonks.org>
Reply-To: Nils Radtke <Nils.Radtke@Think-Future.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030611145856.GT32593@sunbeam.de.gnumonks.org>; from laforge@netfilter.org on Wed, Jun 11, 2003 at 04:58:56PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


        Hello Harald, hello interested reader,

# Nils: which one are you interested in?
 My hope having supplied correct and simple data about the problem didn't
fullfill. I'm sorry if I missed that goal and I'll try to do it better
now:

BIG PICTURE: I use an access point to connect my wireless clients to the
net. I am paranoid regarding data integrity and privacy. So, of course,
WEP is not sufficient. In addition to using VPN (FreeSwan) I implement a
different (compared to the private intranet) subnet on the wireless behalf.


VISUALIZATION:

                 (Internet-)                (Intranet-)
     Internet ---- Gateway ---- Intranet ---- Gateway ---- AccessPoint - - - - wireless_Intranet
DEV:            ppp0    eth0                eth0   eth1     transparent

IP:   any                     private_net               wireless_private_net
                             192.168.1.0/24             172.16.1.0/24


FACT: - Using netfilter to connect Intranet and Internet works. Good.
      - The Intranet Gateway is hosting a whole bunch of services
        configured to accept connections from the Intranet. Works. Good.
PROB: - the clients on air (wireless_Intranet) cannot access the
        services as, obviously, the IP-range is not allowed to connect. Bad.

SOLUTION: - Need to do local SNAT.
          - Map any single IP or IP-range (inbound on eth1 of Intranet-Gateway) 
            from wireless_private_net to a specified single IP or a 
            corresponding specified IP-range belonging to private_net.
            This must be done _before_ the packet reaches a listening
            local process.
            Then the local processes configured to accept IP-addresses from
            private_net only can serve to clients connected via WLAN, too.


I hope this time all information has been clearly stated. If any
questions remain, do not hesitate to address them to me.


        Kind regards,

                Nils Radtke



-- 

* N.Radtke@                 * University of Stuttgart *    icq / lc   *
*      www.Think-Future.de  *    dep.comp.science     * 9336272/92045 *
:x                                                                   :)

   Yesterday is but today's memory, and tomorrow is today's dream.  
   -- Kahlil Gibran 
   
