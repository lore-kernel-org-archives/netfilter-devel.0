From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Where is conntrack in the iptables chain?
Date: Mon, 25 Aug 2003 04:29:04 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825112904.17092.qmail@web13904.mail.yahoo.com>
References: <20030825112217.GF423@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030825112217.GF423@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Lol, ack = act.  Only 1 cup of coffee this morning...


--- Patrick Schaaf <bof@bof.de> wrote:
<snip> 
> That connection lookup happens before all other
> hooks, i.e. before a
> packet enters iptables in the mangle table
> PREROUTING chain. Thus,
> even rules in the prerouting chain can already use
> the tracking
> information.
> 
> Does that answer your question?

Yup.  Are there any examples of how to manipulate
packets prior to conntrack, either as a loadable
module or via iptables?  I seem to recall a patch
which added raw tables that acted before anything else
but do not recall which rev of iptables it acted on...

-Scott

__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
