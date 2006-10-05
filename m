From: Mohammad Farooq <mohammadfarooq@tango-networks.com>
Subject: Re: iptables won't compile in a debug turned on
Date: Thu, 05 Oct 2006 09:16:30 -0500
Message-ID: <1160057790.28977.181.camel@mfarooq-1.tango-networks.com>
References: <1159989997.28977.166.camel@mfarooq-1.tango-networks.com>
	<4524E03C.6070003@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4524E03C.6070003@netfilter.org>
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

On Thu, 2006-10-05 at 12:36 +0200, Pablo Neira Ayuso wrote:
> Mohammad Farooq wrote:
> > Are you guys aware of that is in the iptables-1.3.6/Makefile if turn on
> > debugging:
> > CFLAGS:=$(COPT_FLAGS) -Wall -Wunused -I$(KERNEL_DIR)/include -Iinclude/
> > -DIPTABLES_VERSION=\"$(IPTABLES_VERSION)\" -g -DDEBUG -pg  -DIPTC_DEBUG
> > the compile will fail.
> > 
> > MF
> > 
> > libiptc/libip6tc.c: In function `do_check':
> > libiptc/libip6tc.c:284: warning: implicit declaration of function
> > `get_chain_end'
> > libiptc/libip6tc.c:285: warning: implicit declaration of function
> > `get_entry'
> > [...]
> 
> I didn't notice, it seems that nobody has been using it for quite some
> time. I'm not sure if it is worth fixing this.
> 
When everything works okay, yes this fix may not be needed. I was trying
to debug this problem with the u32 module that it was giving me "Invalid
argument" error. In desperation every bit of information helps.

MF
