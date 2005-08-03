From: "Adam" <netfilter@irotas.net>
Subject: Managing netfilter/iptables via netlink
Date: Wed, 03 Aug 2005 10:41:35 -0400
Message-ID: <1123080095.30594.239892161@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi all,

I need a little clarification regarding Netfilter user-space to
kernel-space IPC. 

I was reading the following article:
http://www.linuxjournal.com/article/7356

The author states: "NETLINK_NFLOG: communication channel for the
user-space iptable management tool and kernel-space Netfilter module."

However, looking into the iptables userspace code, it seems that it
sends directives to the kernel using setsockopt().

My question is this: Is it possible to manage netfilter/iptables from
userspace using netlink? If so, could you point me to some
documentation, or at least some example code? If not, is setsockopt()
currently the only supported mechanism to send firewall directives into
the kernel?

Currently my software uses system("/sbin/iptables ...") for configuring
the firewall, but unfortunately this is no longer an option.

Thanks,
Adam
