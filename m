From: Ury N. Stankevich <ury@bofh.homeunix.org>
Subject: iptables match kernel module
Date: Sat, 2 Nov 2002 22:10:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021102221052.52974370.ury@bofh.homeunix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

hello,
i m trying to create iptables module to match loadavg.
while create kernel module so easy, but how can i take access to
'avenrun' kernel variable?

(module failed to load with ipt_load.o: unresolved symbol avenrun)

__Ury
