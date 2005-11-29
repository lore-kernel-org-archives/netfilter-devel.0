From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Wed, 30 Nov 2005 00:07:49 +0100
Message-ID: <438CDF45.9040308@trash.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051129040925.GC3544@rama.towersoft.de>
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
> No, I oppose any kind of kernel version number checking.  I'd rather
> break 2.6.14 with new versions of the userspace.
> 

The stable tree has a couple of patches pending, so I guess there
will be another release. I'll ask them if they would take a patch
to fix this issue.
