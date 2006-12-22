From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: Network compression...
Date: Fri, 22 Dec 2006 09:08:17 -0500
Message-ID: <9684.1166796497@sandelman.ottawa.on.ca>
References: <200612221139.AA2964652346@todaktech.com>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: safiudeen@todaktech.com
In-Reply-To: Message from "safiudeen" <safiudeen@todaktech.com> of "Fri,
	22 Dec 2006 11:39:50 +0800." <200612221139.AA2964652346@todaktech.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


>>>>> "safiudeen" == safiudeen  <safiudeen@todaktech.com> writes:
    safiudeen> Hi,

    safiudeen> I want to compress TCP/IP packet (payload and IP header)
    safiudeen> in out going packet and uncmpress in incomming packet. Is
    safiudeen> it possible to do this using netfilter hook ?. If
    safiudeen> possible what type of network hook can be used ?.

    safiudeen> I tryed adding a fiew code in side linux kernel TCP/IP
    safiudeen> stack netif_rx () call and dev_queue_xmit (), but kernel
    safiudeen> hang after fiew second.

    safiudeen> If someone already done similor work or know how to do
    safiudeen> this please provide me some informatiom.

  Look at ipcomp.

- -- 
]            Bear: "Me, I'm just the shape of a bear."          |  firewalls  [
]   Michael Richardson,    Xelerance Corporation, Ottawa, ON    |net architect[
] mcr@xelerance.com      http://www.sandelman.ottawa.on.ca/mcr/ |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Finger me for keys

iQEVAwUBRYvm0ICLcPvd0N1lAQJ1/wf/SE5dCarPxNS5rGUnT+ulnpQ2HXjjgLTt
UtDBDM688j/hrod13ah5Gag9SW7Z+jNHKzMjBe0v6x/qJIpVFIXXX078awTnB3Lu
+SYZUFuTnc0P/thMbqaegwA5w9hveZMildMlYFi6gbvHWDKgIqGP3oPkEYNJJNLk
ffWrFf5e36s4I07ufsewe/Gh4PZdlPpW0qILfbmMQgg+YlEev9YgJvcUfpQt4vlL
lu6j8f7TPWrrl8WsJxGk6Wa+IWYhCm2rvyfPdzOwcKeBmhzTLWe6uEhHMKJZjut1
02La500nMxS+cPgVshRKz3WHTetPQ2baGZ+ZnYCPiRsIBBieJKEk9A==
=oao4
-----END PGP SIGNATURE-----
