From: Diadon <diadon@isfera.ru>
Subject: Netfilter problem with new 2.4.22
Date: Tue, 16 Sep 2003 16:11:19 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F66FDE7.3000908@isfera.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

After installing 2.4.22
this chain doesn't work
$IPPROG -A OUTPUT -p tcp --dport 113 -j REJECT --reject-with tcp-reset

On 2.4.21 all works fine
In tcpdump on 2.4.21:
14:41:41.752557 somehost.auth > somehost1.32825: R 0:0(0) ack 217583467
win 0 (DF)

In tcpdump on 2.4.22:
nothing.......


any ideas?
