From: Scott MacKay <scottmackay@yahoo.com>
Subject: extending ipq_packet_msg_t
Date: Mon, 5 May 2003 09:53:08 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030505165308.23470.qmail@web13904.mail.yahoo.com>
References: <20030427123927.GW990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030427123927.GW990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I was curious, what is required to add fields into the
ipq_packte_msg_t structure (passed to userspace
QUEUE)?

I wanted to obtain the physical dev names from the
ebtables patch for userspace queue targets (so
forwards rules go from indev "eth0" to outdev "eth1"
instead of "br0" to "br0").  One way would be to alter
netfilter/ip_queue.c and strcpy the skb's
nf_bridge->physindev->name and
nf_bridge->phyoutdev->name over the indev_name and
outdev_name.
If I wanted to add fields, however, are there any
special concerns aside from recompiling iptables and
kernel?
(this would be for 2.4.20 kernel)

-Scott

__________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo.
http://search.yahoo.com
