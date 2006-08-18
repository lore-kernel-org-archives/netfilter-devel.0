From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: iptables patch for tproxy
Date: Fri, 18 Aug 2006 19:50:56 +0200
Message-ID: <200608181950.57032@nienna>
References: <1155904414.19081.33.camel@supercoco>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: Angel Mieres <amieres@eneotecnologia.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1155904414.19081.33.camel@supercoco>
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


  Hi,

On Friday 18 August 2006 14:33, Angel Mieres wrote:
> Im trying to implement TPROXY(from balabit) to work with squid. Im
> having problems when it has to spoof clients from squid. i think my
> patch for iptables is obsolete or i don't applying correctly.
> Can someone supply me the iptables-1.3.5 patch for tproxy?

  Which iptables patch were you trying to apply?

  You can find an iptables-1.3.x patch in the "official" tproxy tarballs, 
for example in this one:

http://www.balabit.com/downloads/tproxy/linux-2.6/cttproxy-2.6.15-2.0.4.tar.gz

  Oh, and more up-to-date (not yet officially released) kernel patch 
snapshots are available also:

  http://people.balabit.hu/hidden/tproxy2-2.6.16_20060727.tar.bz2
  http://people.balabit.hu/hidden/tproxy2-2.6.17_20060727.tar.bz2
  http://people.balabit.hu/hidden/tproxy2-2.6.18_20060727.tar.bz2

-- 
 Regards,
  Krisztian Kovacs
