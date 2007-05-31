From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Thu, 31 May 2007 06:38:49 +0200
Message-ID: <465E5159.4050604@trash.net>
References: <200705071200.l47C0UoM006287@toshiba.co.jp>
	<e6af3bc80705301643w37922773ge6beab27d229718b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	kadlec@blackhole.kfki.hu
To: Mohammad Mohsenzadeh <mmohsenz@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <e6af3bc80705301643w37922773ge6beab27d229718b@mail.gmail.com>
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

Mohammad Mohsenzadeh wrote:
> Thanks for the patches, applied and works just fine. I was just
> wondering if you would ever consider including these in the main
> release of netfilter??


Thanks for testing. I'm also hoping we can get this ready ASAP
to get rid of the overhead of searching the expectations/helpers
twice. I'm even considering switching to worst-case allocations
for the time being since it costs us quite a bit of performance.
