From: "Paul J. Caritj" <pcaritj@riovia.net>
Subject: Basic API Question
Date: 26 Jun 2003 03:39:46 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056613186.8171.11.camel@localhost.localdomain>
Reply-To: pcaritj@riovia.net
Mime-Version: 1.0
Content-Type: text/plain
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

Geetings,
I am trying to accomplish a very simple task: the addition, removal, etc
of iptables rules through C. I have found ample documentation on
developing modules, etc, but nothing to answer this basic question. 

Does such an interface exist or will I basically have to pipe out shell
commands (eew)?

For the sake of illustration, lets say I wanted to mark all packets
bound to IP [IP] with fw-mark [mark] on the PREROUTING chain.




Thanks all,
Paul
