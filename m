From: Wang Jian <lark@linux.net.cn>
Subject: Re[2]: new REBOOT target
Date: Tue, 01 Mar 2005 13:10:45 +0800
Message-ID: <20050301124005.C845.LARK@linux.net.cn>
References: <20050228090635.GA25632@roonstrasse.net>
	<876ef97a05022818395d69281c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Max Kellermann <max@duempel.org>, netfilter-devel@lists.netfilter.org
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a05022818395d69281c@mail.gmail.com>
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

Hi Tobias DiPasquale,

Thanks for your improvement :)

A note for sendreboot.pl's -I parameter: it is used on multihome host, so
no need to remove it.

Note for ipt_REBOOT.c: KERN_ERROR should be KERN_ERR. But I think check
() should emit KERN_WARNING as other targets do but not KERN_ERR.

With ipt_string, it has no --offset parameter, which can be hazardous
for -j REBOOT in case the passphrase is short. Adding --offset may also give
a little of performance boost to string match.

Will ipt_string go into 2.6 mainline?

PS: Is there any possibility that REBOOT target goes into POM or
mainline? Anyway this toy is trivial :D

On Mon, 28 Feb 2005 21:39:40 -0500, Tobias DiPasquale <codeslinger@gmail.com> wrote:

> On Mon, 28 Feb 2005 10:06:35 +0100, Max Kellermann <max@duempel.org> wrote:
> > On 2005/02/26 15:30, Wang Jian <lark@linux.net.cn> wrote:
> > > # iptables -I INPUT -p icmp -j REBOOT --passphrase pass [--offset offset]
> > > [--hard (0|1)]
> > 
> > Ugly hack for an ugly problem ;) - still, it's an interesting idea for
> > people plagued with such a problem.
> 
> I agree.
>  
> > You have implemented the "--passphrase" parameter in your REBOOT
> > target, but that "--passphrase" is in fact a match, not a target
> > parameter. Targets should not perform a test on the packet, it's not
> > their task (it should not assume the packet is ICMP either, that drops
> > a lot of flexibility). You should implement this part as a match
> > module.
> > 
> > Maybe someone has already written such a module.. look at
> > patch-o-matic.
> 
> They have; its called ipt_string. Use that in conjunction with the
> attached code to implement the functionality you require.
>  
> > In contrary, "--hard" is not a match, it controls what REBOOT should
> > do in detail, so this is one ok.
> 
> Agreed; --hard stuck around for this.
> 
> -- 
> [ Tobias DiPasquale ]
> 0x636f6465736c696e67657240676d61696c2e636f6d



-- 
  lark
