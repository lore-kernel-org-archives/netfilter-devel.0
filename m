From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] Small SMP-race found in ip_conntrack_proto_tcp.c
Date: 24 Oct 2002 17:19:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1035472754.722.129.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I just found a small SMP-race when looking at an ugly lock (tcp_lock) in
ip_conntrack_proto_tcp.c

we use conntrack->proto.tcp.handshake_ack without holding the lock. This
is a very small race as it only applies to the ACK-packet in the
three-way handshake and there will probably only be one of those.

Patch to move the unlock further down is attached, I unlock before
calling ip_ct_refresh as it is unfriendly to hold the lock longer than
neccessary.

I believe this lock can be removed completely in Rusty's
optmization-patches, I'll send a patch for that aswell later.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
