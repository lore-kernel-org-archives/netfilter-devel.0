From: =?iso-8859-2?Q?Pawe=B3?= Krawczyk <kravietz@aba.krakow.pl>
Subject: ICMP reject types?
Date: Tue, 1 Oct 2002 12:07:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021001100755.GC5609@aba.krakow.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Maybe it's my ignorance, but I feel that REJECT target --reject-with
option is somewhat broken - you can set icmp-net-prohibited or
host-prohibited ICMP replies, which are discouraged and obsoleted by RFC
1812, but you cannot use 0/13 ICMP (Admin prohibited), which is the one
recommended by the RFC. Can anyone comment?

-- 
Pawe³ Krawczyk, Kraków, Poland  http://echelon.pl/kravietz/
horses: http://kabardians.com/
crypto: http://ipsec.pl/
