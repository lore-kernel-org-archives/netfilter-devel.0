From: Willy TARREAU <willy@w.ods.org>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 11:11:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229101116.GA10012@pcw.home.local>
References: <20040225182828.GP13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Netfilter Mailinglist <netfilter@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040225182828.GP13386@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

Just tested it on top of 2.4.25, like this :

    KERNEL_DIR=/usr/src/linux-2.4.25-pomng ./runme --batch extra

and I got a few problems :

  - first, I didn't find how to specify where my iptables sources is
    installed, so I had to enter it by hand each time I restarted it.
    I did not find any env variable in the perl code, and I must say
    that my understanding of perl is, hmmm.. very limited.
  - ROUTE and TRACE told me :
    "unable to find ladd slot in src /usr/src/linux-2.4.25-pomng/./net/ipv6/Makefile"
    I think they wanted to add a line in the Makefile but didn't find
    the right place to do so. BTW, is there a way to install a patch
    only for ipv4 or for ipv6 like before ?
  - I observed usual conflicts :
    present 'CONNMARK' conflicts with to-be-installed 'connbytes'
    present 'raw' conflicts with to-be-installed 'conntrack-seqfile'
    present 'CONNMARK' conflicts with to-be-installed 'conntrack_arefcount'
  - and finally, trying to apply conntrack_locking litterally killed my
    box in out of memory within a few tens of seconds (I could not even
    run ps) :
      Out of Memory: Killed process 9841 (runme).
      Out of Memory: Killed process 9970 (ps).
      Out of Memory: Killed process 159 (bash).
      Out of Memory: Killed process 158 (bash).

    Since conntrack_locking needs conntrack_arefcount which could not
    be applied, I wonder if there's some problem resolving dependancies.

I've not gone further yet.
Do you need more info ? There may be some things I did wrong, do not hesitate
to tell me ;-)

Cheers,
Willy
