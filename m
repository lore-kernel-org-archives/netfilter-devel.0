From: Bobo <boboaq@163.com>
Subject: How to log all the packets through netfilter?
Date: Wed, 12 Mar 2003 18:34:8 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030312103355.9C1FF1C9C2DCC@sm206.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org <netfilter@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 Hello:

        While using IPtables,I am now trying to log all the packets the firewall receives.

     Now,I could log such packets that match the set rules.If receive some packet which does 
not meet any rules in a chain,how to log it?
   I have set the default polity of a chain  "drop" action.

     Thanks.
