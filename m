From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables won't compile in a debug turned on
Date: Thu, 05 Oct 2006 12:36:44 +0200
Message-ID: <4524E03C.6070003@netfilter.org>
References: <1159989997.28977.166.camel@mfarooq-1.tango-networks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mohammad Farooq <mohammadfarooq@tango-networks.com>
In-Reply-To: <1159989997.28977.166.camel@mfarooq-1.tango-networks.com>
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

Mohammad Farooq wrote:
> Are you guys aware of that is in the iptables-1.3.6/Makefile if turn on
> debugging:
> CFLAGS:=$(COPT_FLAGS) -Wall -Wunused -I$(KERNEL_DIR)/include -Iinclude/
> -DIPTABLES_VERSION=\"$(IPTABLES_VERSION)\" -g -DDEBUG -pg  -DIPTC_DEBUG
> the compile will fail.
> 
> MF
> 
> libiptc/libip6tc.c: In function `do_check':
> libiptc/libip6tc.c:284: warning: implicit declaration of function
> `get_chain_end'
> libiptc/libip6tc.c:285: warning: implicit declaration of function
> `get_entry'
> [...]

I didn't notice, it seems that nobody has been using it for quite some
time. I'm not sure if it is worth fixing this.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
