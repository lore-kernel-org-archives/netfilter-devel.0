From: "Kim Thye Chua" <kim.thye.chua@aptilo.com>
Subject: netlink_unicast question
Date: Wed, 18 Sep 2002 02:03:41 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OHEAKJJCKHIPCLKINACKCEEHCAAA.kim.thye.chua@aptilo.com>
References: <Pine.LNX.4.44.0209171556190.23114-100000@the.brain.uni-freiburg.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0209171556190.23114-100000@the.brain.uni-freiburg.de>
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

I have a problem when using netlink_unicast(...) in
net/netlink/af_netlink.c. When calling netlink_unicast(...) multiple times,
e.g. in a loop, the internal buffer in the socket will get filled up, then
it will refuse to send any more netlink msg and return -EAGAIN.

Is there anyway to force netlink socket to send/flush whatever in the buffer
thus leave more room for the next netlink_unicast call?

Any advice is appreciated. thank you very much.


/kim
