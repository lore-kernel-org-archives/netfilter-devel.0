From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: -m physdev iptables: Invalid Argument
Date: Sat, 25 Oct 2003 11:38:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310251138.01994.bdschuym@pandora.be>
References: <3F996BBA.5070106@metavize.com> <3F99CB83.1020405@metavize.com> <20031025092117.GA17255@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>,
	Dirk Morris <dmorris@metavize.com>
In-Reply-To: <20031025092117.GA17255@alpha.home.local>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Saturday 25 October 2003 11:21, Willy Tarreau wrote:
> Was your iptables-1.2.9rc1 compiled with 2.6.0test8 headers or with 2.4
> headers ? it might make a difference.

That's indeed the problem, I've just sent a patch on this list that resolves 
this.

cheers,
Bart
