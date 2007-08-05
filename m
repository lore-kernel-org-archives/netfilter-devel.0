From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH] conntrack-tools compilation problem
Date: Sun, 5 Aug 2007 18:03:54 +0200
Message-ID: <20070805160354.GA28674@sch.bme.hu>
References: <20070805153015.GA27598@sch.bme.hu>
	<Pine.LNX.4.64.0708051735550.29913@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing List <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708051735550.29913@fbirervta.pbzchgretzou.qr>
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

Hi,

On Sun, Aug 05, 2007 at 05:36:25PM +0200, Jan Engelhardt wrote:
> >The attached patch fixes this problem for me, although I'm quite sure that
> >it does not break compilation for someone else. (Should not, but I'm not
> >much of an autoconf expert...)
> 
> Given that the lines the patchs adds _already exist_ in libnetfilter_conntrack
> (that is, to properly include libnfnetlink). So that should be fine :)

Yep, but those lines were added by patch of mine long ago, so it's also
possible that I'm just trying to cripple conntrack-tools, too... ;)

-- 
KOVACS Krisztian
