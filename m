From: Patrick Schaaf <bof@bof.de>
Subject: Re: target for modifying conntrack timeout value
Date: Wed, 1 Dec 2004 09:54:48 +0100
Message-ID: <20041201085448.GE4605@oknodo.bof.de>
References: <20041201070025.GD4605@oknodo.bof.de>
	<EINSTEINLR95CBUzN8I000063f8@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
Content-Disposition: inline
In-Reply-To: <EINSTEINLR95CBUzN8I000063f8@einstein.systemmetrics.com>
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

Hi Richard,

> I am thinking to use "ip_ct_refresh" to change the current value of
> conntrack. If it is feasible, the module shouldn't be too hard to write.

conntrack timeouts are set anew for each packet of the connection,
on input, as far as I can tell. Your calling ip_ct_refresh will at
most apply until the next packet of the connection comes by.

> My specific application is for SIP. SIP sends out REGISTER messages to the
> outside server. The server would send any call to the inside client via its
> NAT address. If the conntrack is no longer there, the inside client can't
> receive any SIP message and won't get any call. It needs to keep the
> conntrack active far larger than the 3 minutes default.

Ah. So you would want packet from client->server extend the timeout
to say six hours, so that the eventual incoming call signalling
server->client finds its way to the (hopefully not shut down or
rebooted) SIP end device behind the NAT box.

That should indeed work by calling ip_ct_refresh (ip_ct_refresh_acct
in 2.6, it seems) in e.g. filter, matching --dport 5060. Just make
sure you do it in front of any '-m state --state ESTABLISHED -j ACCEPT'
rules.

Go ahead, write such a target.

best regards
  Patrick

(btw, could you please not top-post?)
