From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?
Date: Tue, 15 Mar 2005 20:07:25 +0100
Message-ID: <4237326D.309@trash.net>
References: <019201c52592$e181a4b0$0a00a8c0@alexandre>
	<42307E2A.5060806@trash.net>
	<019f01c52595$dd3a56b0$0a00a8c0@alexandre>
	<42308509.4040902@trash.net>
	<01cd01c5259a$89ab8dc0$0a00a8c0@alexandre>
	<42308B4E.3030303@trash.net>
	<1110483093.1100.9.camel@tux.rsn.bth.se>
	<42312929.7000102@trash.net> <42312A33.3030603@trash.net>
	<1110545296.3751.16.camel@nienna.balabit>
	<20050312123034.GA27873@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	KOVACS Krisztian <hidden@balabit.hu>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050312123034.GA27873@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Fri, Mar 11, 2005 at 01:48:16PM +0100, KOVACS Krisztian wrote:
> 
>>  BTW, I think SNAT-ting pure local traffic so that it goes out on the
>>wire is a bad practice anyway.
> 
> ack. even if you have broken applications, this should be fixable with
> a LD_PRELOAD wrapper.

I agree, but I would still prefer if it would work as expected for
consistency. Haven't had time to look into fixing it yet.

Regards
Patrick
