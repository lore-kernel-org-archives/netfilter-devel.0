From: Wang Jian <lark@linux.net.cn>
Subject: Re[2]: new REBOOT target
Date: Mon, 28 Feb 2005 17:41:40 +0800
Message-ID: <20050228174120.C816.LARK@linux.net.cn>
References: <20050226215628.C7D1.LARK@linux.net.cn>
	<20050228090635.GA25632@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050228090635.GA25632@roonstrasse.net>
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

Hi Max Kellermann,

See my original post for the note on --offset and --passphrase :)

I know they shouuld be match, and actually, the funcionality is in
string match, partially. Because the kernel I use has no string match
builtin, and I didn't want to compile them, I choose to do the matching
in target itself ;)

It is really ugly hack in some sense. I originally planed to write a
small LKM rootkit to do that, but then I chose netfilter to hook in.
LKM rootkit is more management related ;)

Beside my laziness, the --passphrase is an error-proof mechanism per se.
Let's assume some one wants to use -j REBOOT, but he doesn't specified a
good enough match, just '-p icmp', then boom ;) In this sense, the
--passphrase is not match, but part of target.

On Mon, 28 Feb 2005 10:06:35 +0100, Max Kellermann <max@duempel.org> wrote:

> On 2005/02/26 15:30, Wang Jian <lark@linux.net.cn> wrote:
> > # iptables -I INPUT -p icmp -j REBOOT --passphrase pass [--offset offset]
> > [--hard (0|1)]
> 
> Ugly hack for an ugly problem ;) - still, it's an interesting idea for
> people plagued with such a problem.
> 
> You have implemented the "--passphrase" parameter in your REBOOT
> target, but that "--passphrase" is in fact a match, not a target
> parameter. Targets should not perform a test on the packet, it's not
> their task (it should not assume the packet is ICMP either, that drops
> a lot of flexibility). You should implement this part as a match
> module.
> 
> Maybe someone has already written such a module.. look at
> patch-o-matic.
> 
> In contrary, "--hard" is not a match, it controls what REBOOT should
> do in detail, so this is one ok.
> 
> Max



-- 
  lark
