From: Phil Oester <kernel@linuxace.com>
Subject: Re: Deadlocks
Date: Fri, 18 Jun 2004 10:12:14 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040618171214.GA750@linuxace.com>
References: <20040609180909.GA11445@linuxace.com> <1087156709.11287.8.camel@ws> <20040615044723.GA16891@linuxace.com> <40CE95DE.9090703@trash.net> <20040617155946.GA28564@linuxace.com> <40D1C4BF.8070605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40D1C4BF.8070605@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Well, it lasted about 36 hours -- not much longer than usual.  Unfortunately,
the stack appears to have been corrupted, so I can't get a decent backtrace.
Here is what I could get off of SysRQ-P:

Pid: 0, comm:              swapper
EIP: 0060:[<c0258b15>] CPU: 1
EIP is at tcp_find_option+0x55/0xa0
 EFLAGS: 00000203    Not tainted  (2.6.7)
EAX: 000000fe EBX: 00000040 ECX: 00000002 EDX: 00000034
ESI: 00000018 EDI: f89c39bc EBP: 00000000 DS: 007b ES: 007b
CR0: 8005003b CR2: 080da0b4 CR3: 379cc000 CR4: 000006d0
Stack pointer is garbage, not printing trace

Perhaps of interest, not sure, but the FTP server at 10.0.16.197 frequently
shows duplicate expectations, as shown below shortly after rebooting:

EXPECTING: - use=1 proto=6 src=10.0.16.197 dst=10.0.53.248 sport=0 dport=4353 
EXPECTING: - use=1 proto=6 src=10.0.16.197 dst=10.0.53.248 sport=0 dport=4353 
EXPECTING: - use=1 proto=6 src=10.0.16.197 dst=10.0.53.248 sport=0 dport=4353 

Unless you've got any other ideas, may have to revert this box to non-SMP
so I can have a peaceful weekend ;-)

Phil


On Thu, Jun 17, 2004 at 06:20:15PM +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> >In any event, I have applied your patch to 2.6.7, and am running it.  
> >Typically
> >the box would not last more than a couple days, so I'll let you know what 
> >happens.
> 
> Great, I'm really interested ..
