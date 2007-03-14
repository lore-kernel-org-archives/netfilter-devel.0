From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: NF structural changes (was: dangerous?)
Date: Wed, 14 Mar 2007 21:57:30 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Amin Azez <azez@ufomechanic.net>, Patrick McHardy <kaber@trash.net>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello Ccs,


As a result of the "dangerous? Setting mark in nat table" thread, I have 
just drawn this idea of mine down, where:

 - filter and mangle tables are merged
 - filtering comes early, even before nat
   (so that, for example, packets do not needlessy be MARKed, mangled, etc.)

Pic: http://jengelh.hopto.org/GFX0/nf_proposal.png (or .svg)
(Yes, it's reminiscient of http://imagestream.com/~josh/PacketFlow-new.png )

Comments welcome.


Jan
-- 
