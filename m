From: "kesineni sai pratap" <kesineni@woojininc.net>
Subject: It is possible to route the bridge packet?
Date: Fri, 20 Aug 2004 15:49:11 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001801c48681$cd08ddb0$a06464c0@kesineni>
References: <20040819121547.15140.70414.Mailman@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
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

Hello ,

        I configured bridge in between two interfaces eth1 , eth2. when
packet arrives at eth1 , pass through the bridge reaches the eth2. My
requirement is  send this packets to routing  module, route the packet. I
change linux source code making  a way for packet to go another interface.
iam getting problem in ip_route_input_slow because of fib_lookup.because of
that reason my system hangs.

i cannot undersand what is the problem?

any body can give some suggestions

thanks
LEO

.
