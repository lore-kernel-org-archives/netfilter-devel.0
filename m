From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 00/10] nfnetlink_log: patch series introduction
Date: Mon, 12 Feb 2007 01:37:38 +0100
Message-ID: <20070212003738.GA8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964800AbXBLJJi@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Dear list,

After meeting a faint-hearted Linux kernel lately I decided to try myself
at persuading it to not be afraid of NFLOG. This chat gave a series of
ten commandments I present today. Take a look and agree or comment.

Here's the list:

  1. nfulnl_log_packet() - don't count the same thing twice
* 2. nfulnl_log_packet() - don't leak references
  3. nfulnl_log_packet() - don't copy-and-paste code
* 4. nfulnl_timer() - don't touch freed memory
  5. nfulnl_recv_config() - don't free what isn't there
  6. nfulnl_recv_config() - don't touch dead animals
* 7. instance_destroy() - remember of your appointments
  8. instance_create() - don't lock the bookshelf for too long
! 9. __build_packet_message() - don't forget your tail
 10. instance_create() - wear your watch when going out

Ninth is THE one. Those marked with stars are important I believe.
Others came out on the way. I'll send them one-in-a-mail right after
this message. I'm CC:ing this to LKML, so someone could put the important
ones in -stable maybe?

Have a nice reading,
Michal Miroslaw

PS. Please CC: me if you need my answer as I read the list's archive
only and I am not subscribed.
