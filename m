From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU (Patrick McHardy)
Date: Mon, 17 Feb 2003 14:08:27 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15953.23899.11883.368569@isis.cs3-inc.com>
References: <20030216200158.GB29764@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.33.0302170954580.5567-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0302170954580.5567-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 > The ICMP error sent back is tricky. What should we send back: the
 > offending fragment? Or header of the defragmented packet with the
 > size of the too big fragment as packet length would be just fine?
You might be interested in the trick I've been using:
if you expand the packet by n bytes and have to send an icmp complaint
then reduce the size of what you claim to be the MTU by n.

near end of ip_forward:
        icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
                  htonl(mtu - <* amount added *>));

I suspect this has never been an issue in existing kernel code cause
changing packet length has been rare and probably only occurred in
short packets.
