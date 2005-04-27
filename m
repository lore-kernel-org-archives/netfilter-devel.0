From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] owner-socketlookup update for 2.6.12-rc3
Date: Wed, 27 Apr 2005 08:55:09 +0200
Message-ID: <20050427065509.GB5828@oknodo.bof.de>
References: <Xine.LNX.4.44.0504270021020.15959-100000@thoron.boston.redhat.com>
	<Xine.LNX.4.44.0504270200190.16150-100000@thoron.boston.redhat.com>
	<20050426231328.0ab5b357.davem@davemloft.net>
	<20050427064304.GA5828@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20050427064304.GA5828@oknodo.bof.de>
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

Completely different question re semantics: what about listening sockets,
and the incoming connection requests to them?

How would the initial SYN be classified by a LOCAL_IN owner match?
Consider the case that a uid:0 process created the listening socket,
then dropped to uid:1234 and execed a different binary.

best regards
  Patrick
