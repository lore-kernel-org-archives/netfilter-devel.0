From: <kron@innerghost.net>
Subject: mangle feature
Date: Wed, 17 Dec 2003 16:26:51 -0000 (WET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <35253.193.136.173.42.1071678411.squirrel@www.innerghost.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

well i working in a project that consist in a criation of secure channel
at transport layer in a vpn.My ideia is change the payload between client and server/vpn, i think use
mangle was a good idea bacause mangle can change some info of packets like
TOS and TTL but not the payload, what i want is implement a new feature
that change the payload and recalculate the checksum, but i need some
documention that help me to do this.documention like "hacking mangle" or "add new features in iptables" , i
search around here but i don't find anything i wanted.Anyone for helping me ?
