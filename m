From: Patrick Schaaf <bof@bof.de>
Subject: Re: How to test iptables' filtering speed?
Date: Sat, 27 Nov 2004 08:56:55 +0100
Message-ID: <20041127075655.GA4605@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert <hanbo163com@163.com>
Content-Disposition: inline
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

Hello Robert,

> For some reason I want to get the time that iptables handle a packet,I mean the time form the packet come into the hook to the packet go outof the hook or be thown. I want an average value,any one can help me??

I once made a patch for that. Archived here:

https://lists.netfilter.org/pipermail/netfilter-devel/2002-July/008788.html

That should get you started.

best regards
  Patrick
