From: Leen Besselink <leen@wirehub.nl>
Subject: RE: Some one knows how to implement policy routing with iptables?
Date: Thu, 26 Aug 2004 09:07:19 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.BSF.4.56.0408260905360.29241@poindexter.wirehub.nl>
References: <HGEFKOBCHAIJDIEJLAKDMEJKCAAA.sumit@elitecore.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <HGEFKOBCHAIJDIEJLAKDMEJKCAAA.sumit@elitecore.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Aug 2004, Sumit Pandya wrote:

> > From: "Robbert" <hanbo163com@163.com>
> >
> > Some one knows how to implement policy routing with iptables?
> > Can I do that ONLY with iptabales?
> 	Have you seen ROUTE target?
>

I suggest you (Robert) take a look at:

http://www.lartc.org/

Policy Routing is explained there.

(the only relation that iptables has with it is that you can mark certain
packet which should have a policy)
