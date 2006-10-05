From: Phil Oester <kernel@linuxace.com>
Subject: Re: iptables won't compile in a debug turned on
Date: Thu, 5 Oct 2006 13:51:44 -0700
Message-ID: <20061005205144.GA25940@linuxace.com>
References: <1159989997.28977.166.camel@mfarooq-1.tango-networks.com>
	<4524E03C.6070003@netfilter.org>
	<1160057790.28977.181.camel@mfarooq-1.tango-networks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mohammad Farooq <mohammadfarooq@tango-networks.com>
Content-Disposition: inline
In-Reply-To: <1160057790.28977.181.camel@mfarooq-1.tango-networks.com>
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

On Thu, Oct 05, 2006 at 09:16:30AM -0500, Mohammad Farooq wrote:
> When everything works okay, yes this fix may not be needed. I was trying
> to debug this problem with the u32 module that it was giving me "Invalid
> argument" error. In desperation every bit of information helps.

Only enable the "-g -DDEBUG -pg" debug options - not the last one.

Phil
