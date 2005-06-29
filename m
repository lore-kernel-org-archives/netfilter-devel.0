From: Patrick Schaaf <bof@bof.de>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Wed, 29 Jun 2005 17:40:49 +0200
Message-ID: <20050629154049.GA17717@oknodo.bof.de>
References: <42C2C053.3040707@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <42C2C053.3040707@tac.ch>
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

> My question is, if anyone sees any problems with this, regarding performance
> degradation on 32bit boxes or with caching problems?

The problem is compatibility with older versions of the LOG target,
both Userlevel (iptables .so module), and Kernel.

You can either make this a new target, or look how the versioning
infrastructure discussed here some months ago, worked out. (I don't
know; maybe there's already a HOWTO, or you want to write one :)

best regards
  Patrick
