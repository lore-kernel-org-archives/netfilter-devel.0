From: Patrick Schaaf <bof@bof.de>
Subject: Re: inode recognition in ipt_owner module
Date: Mon, 15 Aug 2005 08:27:30 +0200
Message-ID: <20050815062730.GA5919@oknodo.bof.de>
References: <fdbb9d90050813104632639c70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ori bar <tohava@gmail.com>
Content-Disposition: inline
In-Reply-To: <fdbb9d90050813104632639c70@mail.gmail.com>
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

Hello ori,

> ipt_owner as it currently is very problematic in matching packets from
> a specific app.

This is correct. Soon it will be impossible. The feature is just being
removed from ipt_owner. iptables operates on the IP router level.

> (for those of us who want to use it "a-la personal firewall").

Personal firewalls are insecure by design. Bad applications can
easily write their bad code to a different executable name,
and start that.

> Does anybody want me to try implementing it and send it somewhere
> (notice: i never developed kernel modules, i only read them so far, so
> i may need some help here)?

The people who constantly develop kernel modules, have the opinion
that it cannot be done properly. So they are removing it altogether.

Your chances to do it, never having developed kernel modules, are 0.

And even if you were to succeed, you would now have to maintain and
distribute the changes on your own.

best regards
  Patrick
