From: lmn@mail.xprtsol.com
Subject: change ip address in the hook
Date: Sun, 28 Mar 2004 16:57:38 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040328215738.GA19392@mail.xprtsol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

For example, I want to change the ip address of a packet in the LOCAL_OUT hook and let it send out, but I didn't see the packet on the wire. (Route for the modified ip addresses existed.) Similar things happen for the PRE_ROUTING hook. This is like doing the NAT manually.

If I use iptables command to add a rule doing the similar function, I can see the packet was sent out. So what is the difference inside these two approaches?

Thanks,

LMN
