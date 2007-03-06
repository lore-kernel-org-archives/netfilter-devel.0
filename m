From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 4/7 parse attributes with nfattr_parse in
	nfnetlink_check_attribute
Date: Tue, 6 Mar 2007 22:45:27 +0100
Message-ID: <20070306214527.GD521@postel.suug.ch>
References: <45D0EE40.4050404@netfilter.org> <45D19B7A.5080305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <45D19B7A.5080305@trash.net>
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

* Patrick McHardy <kaber@trash.net> 2007-02-13 12:05
> Pablo Neira Ayuso wrote:
> > [PATCH] parse attributes with nfattr_parse in nfnetlink_check_attribute
> > 
> > Use nfattr_parse to parse attributes, this patch also modifies the default 
> > behaviour since unknown attributes will be ignored instead of returning 
> > EINVAL. This ensure backward compatibility: new libraries with new 
> > attributes and old kernels can work.
> 
> Currently other netlink subsystems return errors for the first level
> of attributes and accept unknown attributes on deeper levels. I'm
> not sure which I prefer, ignoring unknown attributes makes it
> impossible for userspace to know that something isn't going to have
> any effect, returning an error makes it harder to support new features.
> 
> I know Thomas had intentions of increasing consistency in this area,
> I'm just not sure in which direction :)
> 
> Thomas, what do you think of this patch?

I believe that all unknown attributes should be ignored so recent
userspace code can function on older kernels. That's the way I'm
working towards.
