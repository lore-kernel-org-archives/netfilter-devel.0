From: Thomas Spatzier <tspat@de.ibm.com>
Subject: Re: ip_conntrack memory leak?
Date: Tue, 1 Jun 2004 09:35:39 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <200406010935.40119.tspat@de.ibm.com>
References: <9e3aacf404052815384498ae20@mail.gmail.com>
Reply-To: tspat@gmx.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
To: linux-net <linux-net@vger.kernel.org>,
	netfilter <netfilter@lists.netfilter.org>,
	nf-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <9e3aacf404052815384498ae20@mail.gmail.com>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

> Hi all,
> 
> I am noticing what appears to be a memory leak in conntrack on one of
> my boxes. The machine is a single 2.4GHz P4 1U rackmount with software
> RAID 1 on 2 40GB IDE HDDs and an onboard e1000 (eth0) and e100 (eth1).
> The kernel is 2.4.26 from kernel.org with ip_conntrack compiled
> statically into the kernel.
> 
> The conntrack slab (/proc/slabinfo) grows without bound and the
> machine needs to be rebooted every few days in order to prevent it
> from running out of memory. This machine is the most heavily loaded
> box I have; it is a stateful firewall and pseudo-bridge for a
> high-traffic subnet. The important thing to note here is that the
> number of active objects reported by /proc/slabinfo is far below the
> number that is reported by a cat /proc/net/ip_conntrack. There are
> ~70K entries in /proc/net/ip_conntrack, whereas /proc/slabinfo reports
> several times that many active objects in the slab. As well, the
> number of active objects keeps going up over time while the number of
> objects reported by /proc/net/ip_conntrack stays relatively the same.
> 
> Has anyone experienced a similar memory leak in this area?
> 

A few weeks ago I posted to these list reporting a similar problem, however
on Linux 2.6. The problem I had (and still have) is that when I have
ip_conntrack enabled on a router I lose memory over time. An extreme
example: a flood ping with packets of size 64K over this router results in
a memory leak of about 10MB per second. The problem did only occur if
packets larger than MTU size were sent, which looks like there is a
problem in ip_conntrack reassembly (possibly refcounting for slab objects ?).
The behaviour of the slab cache is exactly the same as you described it.

-- 
Regards,
Thomas.
