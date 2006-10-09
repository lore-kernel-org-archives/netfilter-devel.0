From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables won't compile in a debug turned on
Date: Mon, 09 Oct 2006 17:24:35 +0200
Message-ID: <452A69B3.80802@trash.net>
References: <1159989997.28977.166.camel@mfarooq-1.tango-networks.com>
	<4524E03C.6070003@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Mohammad Farooq <mohammadfarooq@tango-networks.com>
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

Pablo Neira Ayuso wrote:
> Mohammad Farooq wrote:
> 
>>Are you guys aware of that is in the iptables-1.3.6/Makefile if turn on
>>debugging:
>>CFLAGS:=$(COPT_FLAGS) -Wall -Wunused -I$(KERNEL_DIR)/include -Iinclude/
>>-DIPTABLES_VERSION=\"$(IPTABLES_VERSION)\" -g -DDEBUG -pg  -DIPTC_DEBUG
>>the compile will fail.
>>
>>MF
>>
>>libiptc/libip6tc.c: In function `do_check':
>>libiptc/libip6tc.c:284: warning: implicit declaration of function
>>`get_chain_end'
>>libiptc/libip6tc.c:285: warning: implicit declaration of function
>>`get_entry'
>>[...]
> 
> 
> I didn't notice, it seems that nobody has been using it for quite some
> time. I'm not sure if it is worth fixing this.

I would certainly accept a patch to fix this, but I don't think its
very important.
