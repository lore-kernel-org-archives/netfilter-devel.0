From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_tcpudp.c: wrong struct in udp_checkentry
Date: Wed, 29 Aug 2007 19:12:09 +0200
Message-ID: <46D5A8E9.3090500@trash.net>
References: <BFECAF9E178F144FAEF2BF4CE739C668039A0C6D@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jesper Bengtsson <jesper.bengtsson@axis.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668039A0C6D@exmail1.se.axis.com>
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

Jesper Bengtsson wrote:
> I found what looks like a copy-paste error in udp_checkentry, see patch
> below.
> It doesn't seem to have any effect on the x86 architecture but it does
> have effect on the Axis CRIS architecture.


Thanks, please send me a Signed-off-by: line so I can apply it.
