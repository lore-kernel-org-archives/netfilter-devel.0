From: Patrick Schaaf <bof@bof.de>
Subject: Re: writing a fragmentation-needed patch
Date: Sun, 30 Mar 2003 11:35:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030330093514.GA1098@oknodo.bof.de>
References: <3E85D60D.7040304@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
Content-Disposition: inline
In-Reply-To: <3E85D60D.7040304@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I have written a patch for ipt_REJECT that enables iptables to send back 
> fragmentation-needed. This is useful for testing PMTUD problems. It 
> works for me now, but needs some polishing before I release it.
> 
> Questions:
> - Would such a patch have a chance to be submitted to pom?

Two questions:

- why is it a patch against REJECT, instead of a standalone target?
- how would you concretely use it to test PMTUD problems?

best regards
  Patrick
