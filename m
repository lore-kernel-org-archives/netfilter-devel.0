From: Didier Tournier <Didier.TOURNIER@gemplus.com>
Subject: update iptables rule from a target module...
Date: Thu, 05 Dec 2002 11:54:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DEF307E.4000100@gemplus.com>
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

Hi all,
Is there anybody that could help me with what's following ...
I need to create a new binding rule from a target function of my target 
module loaded by iptables.
this rule is : iptables -t nat -A PREROUTING -d 192.168.0.250 -j DNAT 
--to 10.10.29.50
I've tried to make it with a "do_exec", but that dont work and it could 
be better to update the table directly.
Is there a way to do that? some examples ...

Thanks in advance
Didier
