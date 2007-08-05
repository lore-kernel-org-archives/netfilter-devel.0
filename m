From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] conntrack-tools compilation problem
Date: Sun, 5 Aug 2007 17:36:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708051735550.29913@fbirervta.pbzchgretzou.qr>
References: <20070805153015.GA27598@sch.bme.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailing List <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070805153015.GA27598@sch.bme.hu>
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


On Aug 5 2007 17:30, KOVACS Krisztian wrote:
>
>The attached patch fixes this problem for me, although I'm quite sure that
>it does not break compilation for someone else. (Should not, but I'm not
>much of an autoconf expert...)

Given that the lines the patchs adds _already exist_ in libnetfilter_conntrack
(that is, to properly include libnfnetlink). So that should be fine :)


	Jan
-- 
