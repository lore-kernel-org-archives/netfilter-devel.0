From: Massimiliano Cuzzoli <mcuzzoli@mbigroup.it>
Subject: Problem with extended-match deletion
Date: Mon, 18 Aug 2003 17:34:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F40F210.3050704@mbigroup.it>
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
I've wrote a new match for iptables 1.2.7a.
All features, that I've implemented in it, run very well but
there is a problem when I try to remove the rule with my match.
I execute iptables command with "-D" option and the same parameters of 
rule insertion.

EXAMPLE:

Insert:
$> iptables -I PREROUTING -t mangle -m my_match --my_option -j DROP

Delete:
$> iptables -D PREROUTING -t mangle -m my_match --my_option -j DROP

Then I've received the following message:

"iptables: Bad rule (does a matching rule exist in that chain?)"

There isn't any problem if I remove the rule with a FLUSH operation "-F".

Can Anybody help me???

Regards,

	Mike-Ro-Chanel
