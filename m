From: Wang Jian <lark@linux.net.cn>
Subject: Re[2]: new REBOOT target
Date: Tue, 01 Mar 2005 13:14:05 +0800
Message-ID: <20050301131208.C848.LARK@linux.net.cn>
References: <20050228174120.C816.LARK@linux.net.cn>
	<20050301002058.GA981@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050301002058.GA981@roonstrasse.net>
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


On Tue, 1 Mar 2005 01:20:58 +0100, Max Kellermann <max@duempel.org> wrote:

> On 2005/02/28 10:41, Wang Jian <lark@linux.net.cn> wrote:
> > Beside my laziness, the --passphrase is an error-proof mechanism per
> > se.  Let's assume some one wants to use -j REBOOT, but he doesn't
> > specified a good enough match, just '-p icmp', then boom ;) In this
> > sense, the --passphrase is not match, but part of target.
> 
> (my first reply to you didn't get to the list, maybe a mailman
> failure?)
> 
> Now what about an error proof admin? ;)
> 
> Sorry, I don't think this is a good argument, don't try to find an
> excuse for writing a dangerous rule (and for writing such a netfilter
> "design violation"). If an admin is brave enough to compile REBOOT
> into the kernel and write "-j REBOOT" somewhere, it's his own fault he
> didn't implement the correct match. Someone with root access should
> know better.
> 
> REBOOT should ... reboot! Not match the protocol or a certain pass
> phrase.


Can't agree more :)

> 
> Max



-- 
  lark
