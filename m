From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: new REBOOT target
Date: Mon, 28 Feb 2005 21:39:40 -0500
Message-ID: <876ef97a05022818395d69281c@mail.gmail.com>
References: <20050226215628.C7D1.LARK@linux.net.cn>
	<20050228090635.GA25632@roonstrasse.net>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_404_10550031.1109644780563"
Cc: netfilter-devel@lists.netfilter.org
To: Max Kellermann <max@duempel.org>
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

------=_Part_404_10550031.1109644780563
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 28 Feb 2005 10:06:35 +0100, Max Kellermann <max@duempel.org> wrote:
> On 2005/02/26 15:30, Wang Jian <lark@linux.net.cn> wrote:
> > # iptables -I INPUT -p icmp -j REBOOT --passphrase pass [--offset offset]
> > [--hard (0|1)]
> 
> Ugly hack for an ugly problem ;) - still, it's an interesting idea for
> people plagued with such a problem.

I agree.
 
> You have implemented the "--passphrase" parameter in your REBOOT
> target, but that "--passphrase" is in fact a match, not a target
> parameter. Targets should not perform a test on the packet, it's not
> their task (it should not assume the packet is ICMP either, that drops
> a lot of flexibility). You should implement this part as a match
> module.
> 
> Maybe someone has already written such a module.. look at
> patch-o-matic.

They have; its called ipt_string. Use that in conjunction with the
attached code to implement the functionality you require.
 
> In contrary, "--hard" is not a match, it controls what REBOOT should
> do in detail, so this is one ok.

Agreed; --hard stuck around for this.

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d

------=_Part_404_10550031.1109644780563
Content-Type: application/x-gzip; name="REBOOT.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="REBOOT.tgz"

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
------=_Part_404_10550031.1109644780563--
