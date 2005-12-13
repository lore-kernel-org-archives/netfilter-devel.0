From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Tue, 13 Dec 2005 12:32:20 +0100
Message-ID: <439EB144.4010609@eurodev.net>
References: <Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
	<43864DC7.6060109@trash.net>
	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>
	<20051125084427.GL31478@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>
	<438710E1.2000202@trash.net> <4387A946.3000005@eurodev.net>
	<Pine.LNX.4.64.0511272313570.28434@bizon.gios.gov.pl>
	<20051129040925.GC3544@rama.towersoft.de>
	<438CDF45.9040308@trash.net>
	<Pine.LNX.4.64.0512131041090.928@bizon.gios.gov.pl>
	<439EAEDB.8080207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <439EAEDB.8080207@trash.net>
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

Hi Patrick,

Patrick McHardy wrote:
> Krzysztof Oledzki wrote:
> 
>> The review cycle for the 2.6.14.4 was started. I can't find this fix
>> in listed patches and it seems 2.6.14 needs little different patch
>> than 2.6.15: s/size_t/int/.
>>
>> Patch attached, not sure what to do with Signed-off-by lines so please
>> feel free to correct it.
>>
>> Any chances for submitting it into -stable for inclusion in 2.6.14.4?
> 
> 
> Sorry, I wanted to wait until the patch hit Linus' tree and
> forgot about it. Unfortunately ctnetlink has a number of other
> issues in 2.6.14 that don't fulfil the -stable requirements,
> so in the end its still pretty unusable.
> 
> Anyway, this patch fixes a deadlock when dumping the conntrack
> table which has already hit a number of people. Please consider
> for -stable.
> 
> The patch Krzysztof attached went into 2.6.15-rc and fixes an
> attribute sizes that was used inconsistently. Without this patch
> compatiblity will break once we fix up the userspace side. The
> first released kernel with ctnetlink was 2.6.14, so far the only
> user known to me is a tool in beta-stage that lives in netfilter
> SVN. We would prefer to have no incompatiblities between at least
> 2.6.14.x and later kernels, so is something like this acceptable
> for -stable? If yes I'll send a patch that applies cleanly to
> 2.6.14.3.

The userspace part (libnetfilter_conntrack) is GPL at the moment, I
don't known any other GPL tool using the library at the moment apart
from the conntrack-tool. So I wouldn't care so much about breaking third
party applications that are not fulfilling the licensing requirements.

-- 
Pablo
