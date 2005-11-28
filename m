From: rmkml <rmkml@free.fr>
Subject: pb fingerprint icmp on netfilter/linux
Date: Mon, 28 Nov 2005 10:16:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511281009250.1323@npre.npre.pbz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,
I have a little pb, Im received icmp ping echo request,
normaly echo request are type 8 and code 0,
but this echo request are type 8 and code 19 !
my iptables rules is :
  iptables -A INPUT -j ACCEPT -p icmp --icmp-type echo-request

maybe add check code on netfilter ?

another question, but this is not good list, but send my question,
why linux kernel 2.6.7 (my test), accept and reply type 0 code 19 ?
(code 19 is unknown)

Regards
Rmkml
