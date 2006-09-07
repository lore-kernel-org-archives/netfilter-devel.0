From: Martijn Posthuma <m.posthuma@sangine.com>
Subject: Re: SYN,URG combination considered INVALID by tcp conntrack
Date: Thu, 7 Sep 2006 09:08:59 +0200
Message-ID: <20060907090859.d246b66a.m.posthuma@sangine.com>
References: <20060906144746.446d813c.m.posthuma@sangine.com>
	<44FF118A.3090502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44FF118A.3090502@trash.net>
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

On Wed, 06 Sep 2006 20:20:58 +0200
Patrick McHardy <kaber@trash.net> wrote:

> Please break your lines at 72 characters ..
> 
> Martijn Posthuma wrote:
> > We have been experiencing problems with tcp connection establishment  when (for some reason) the URG flag and pointer were set in the SYN segment. The problem did not affect all machines that were contacted but a subset. All affected machines were using netfilter-conntrack and firewalling. Inspection of the conntrack code (on a 2.6 linux kernel source) reveiled that the above mentioned combination of flags is not considered valid. The code I am referring to is in  nf_conntrack_proto_tcp.c version 2.2, lines 768 to 795:
> 
> Not sure if I understand you correctly, did the machines running
> connection tracking emit these packets?

Nope, these packets were not accepted on boxes using a statefull firewall. The INPUT filter contained lines like this:
ACCEPT tcp 0.0.0.0/0 0.0.0.0/0 -m state --state ESTABLISHED
ACCEPT tcp 0.0.0.0/0 0.0.0.0/0 --dport 22 -m state --state NEW
The firewall uses the conntrack state to filter packets. A segment containing SYN and URG won't get us a connection in state NEW but INVALID, thus the packet is dropped..

[snip]
> > Does someone know of a good reason that this flag combination is excluded?
> 
> No, I guess it should be considered valid. Out of interest, did the
> SYN packets actually carry data?

Not in this case (it turned out to be a non initialized variable). We are hoping to be able to do this in the future to ie speed up the restart of a interrupted ftp-session.

-- 
Martijn Posthuma - software engineer Sangine
www.sangine.com t:+32 (0)14 472 576 f:+32 (0)14 472 582
