From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: new match: userindex
Date: Wed, 8 Dec 2004 14:18:34 +0100
Message-ID: <20041208131834.GA20371@oknodo.bof.de>
References: <3801.217.169.232.210.1102511374.squirrel@hupie.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ferry Huberts <ferry@Hupie.com>
Content-Disposition: inline
In-Reply-To: <3801.217.169.232.210.1102511374.squirrel@hupie.xs4all.nl>
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

> Kernel module for attaching a user specified index to a rule.
> It matches every packet in order to have no influence on packet matching,
> the only effect is to add a user index to a rule

I think this is already covered - in extended form, i.e. arbitrary string
instead of an integer - by the comment match, found in patch-o-matic.

best regards
  Patrick
