From: Kiran Kumar <immidi_kiran@yahoo.com>
Subject: Conntrack TCP query
Date: Wed, 10 Mar 2004 07:29:08 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040310152908.55446.qmail@web14010.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
  In the TCP conntrack code ip_conntrack_proto_tcp.c,
I find that state of the conntrack is updated based on
a table of direction vs cur state vs packet type. This
is ostensibly before verifying the TCP checksum and
other checks. It is then possible that such a packet
is actually dropped. But the conntrack has already
updated the state based on this packet.

  Where am I going wrong?

=====
Regards,
Kiran Kumar Immidi

__________________________________
Do you Yahoo!?
Yahoo! Search - Find what you’re looking for faster
http://search.yahoo.com
