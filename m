From: Max Kellermann <max@duempel.org>
Subject: Re: new REBOOT target
Date: Mon, 28 Feb 2005 10:06:35 +0100
Message-ID: <20050228090635.GA25632@roonstrasse.net>
References: <20050226215628.C7D1.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Wang Jian <lark@linux.net.cn>
Content-Disposition: inline
In-Reply-To: <20050226215628.C7D1.LARK@linux.net.cn>
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

On 2005/02/26 15:30, Wang Jian <lark@linux.net.cn> wrote:
> # iptables -I INPUT -p icmp -j REBOOT --passphrase pass [--offset offset]
> [--hard (0|1)]

Ugly hack for an ugly problem ;) - still, it's an interesting idea for
people plagued with such a problem.

You have implemented the "--passphrase" parameter in your REBOOT
target, but that "--passphrase" is in fact a match, not a target
parameter. Targets should not perform a test on the packet, it's not
their task (it should not assume the packet is ICMP either, that drops
a lot of flexibility). You should implement this part as a match
module.

Maybe someone has already written such a module.. look at
patch-o-matic.

In contrary, "--hard" is not a match, it controls what REBOOT should
do in detail, so this is one ok.

Max
