From: Philip Ho <cbho@ie.cuhk.edu.hk>
Subject: TTL target cannot set
Date: Thu, 06 Mar 2003 11:00:05 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E66B9B5.3CA3D5E8@ie.cuhk.edu.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello

I can't use TTL target, my version is 1.2.7a already. Can anyone tell me
solution?

[/root]# iptables -V
iptables v1.2.7a
[/root]# iptables -t mangle -A OUTPUT -j TTL --ttl-set 126
iptables: No chain/target/match by that name

Regards,
philip
