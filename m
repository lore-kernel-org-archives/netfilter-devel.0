From: "Ferry Huberts" <ferry@Hupie.com>
Subject: RE: DNAT & SNAT delay
Date: Thu, 16 Jun 2005 15:52:04 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAfajkEhWYmEujHL9i1sFkoMKAAAAQAAAA/RNGidHce0OMX8z0INY9LgEAAAAA@hupie.com>
References: <Pine.LNX.4.61.0506161548280.27104@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Jan Engelhardt'" <jengelh@linux01.gwdg.de>,
	"'Martin Bangiev'" <martin.bangiev@borsabg.com>
In-Reply-To: <Pine.LNX.4.61.0506161548280.27104@yvahk01.tjqt.qr>
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

> > Thanks guys
> > I'm using 2.6 kernel and I did
> > echo "0" > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
> > everything works perfectly now:)
> 
> Does not that turn off UDP connection tracking at all?

Yes it does.

That's why I said to restore the timeout value AND that it's a hack...

It's better to use the libctnetlink stuff and conntrack from Pablo (although
they're in CVS only for now)

Ferry
