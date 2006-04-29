From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: RFC: NAT configuration over ctnetlink
Date: Sat, 29 Apr 2006 17:39:37 +0200
Message-ID: <445388B9.2010308@netfilter.org>
References: <4451BA40.4050207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4451BA40.4050207@trash.net>
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

Hi Patrick!

Patrick McHardy wrote:
> I added ctnetlink support to a SIP proxy (siproxd) yesterday and
> stumbled over some problems with NAT. The CTA_NAT attribute only
> allows to set up a single manip, since NAT mappings can't be
> changed for existing conntracks there is no way to add both a
> src- and a dst-manip. This patch removes the overloading of the
> status bits with netlink-relevant semantic and changes the CTA_NAT
> attribute to CTA_NAT_SRC and CTA_NAT_DST. It breaks compatiblity,
> but I don't think its worth trying to keep it for this stupid
> behaviour. Any comments?

Why not keep using the status bits logic? It doesn't break anything and 
you can still add support for source and destination NAT handlings at 
the same time. Is the status thing so ugly to break this?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
