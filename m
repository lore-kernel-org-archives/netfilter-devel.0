From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Conntrack TCP query
Date: Wed, 10 Mar 2004 16:56:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0403101653570.14367-100000@blackhole.kfki.hu>
References: <20040310152908.55446.qmail@web14010.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kiran Kumar <immidi_kiran@yahoo.com>
In-Reply-To: <20040310152908.55446.qmail@web14010.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Mar 2004, Kiran Kumar wrote:

>   In the TCP conntrack code ip_conntrack_proto_tcp.c,
> I find that state of the conntrack is updated based on
> a table of direction vs cur state vs packet type. This
> is ostensibly before verifying the TCP checksum and
> other checks. It is then possible that such a packet
> is actually dropped. But the conntrack has already
> updated the state based on this packet.

Yes. Check out the tcp-window-tracking patch in patch-o-matic which
implements more correct TCP connection tracking.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
