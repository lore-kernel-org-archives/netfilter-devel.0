From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [ANNOUNCE] Release of iptables-1.2.9
Date: Fri, 7 Nov 2003 08:35:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031107073518.GA1215@alpha.home.local>
References: <20031102171611.GF1536@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Core Team <coreteam@netfilter.org>,
   Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
   Netfilter Mailinglist <netfilter@lists.netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031102171611.GF1536@sunbeam.de.gnumonks.org>
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

> 	http://www.netfilter.org/files/iptables-1.2.9.tar.bz2
> 	ftp://ftp.netfilter.org/pub/iptables/iptables-1.2.9.tar.bz2

I was wondering why this file was nearly 50kB bigger than rc1. In fact, the
archive contains some old files, totalizing about 160 kB :

  extensions/.#libipt_ECN.c.1.7
  extensions/.#libipt_recent.c.1.6
  .#iptables.c.1.54
  .#iptables.c.1.55
  libiptc2/.libiptc.c.1.40

That's harmless however. I will probably upgrade today some hosts on which
I installed rc1 a few days ago and which didn't have any problem with it.

Cheers,
Willy
