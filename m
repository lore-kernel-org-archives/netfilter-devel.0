From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 17:18:16 +0200
Message-ID: <200604281718.16912@nienna>
References: <200604201919.19246.max@nucleus.it>
	<Pine.LNX.4.58.0604281455520.20380@blackhole.kfki.hu>
	<4452138E.7050402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4452138E.7050402@trash.net>
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


  Hi,

On Friday 28 April 2006 15.07, Patrick McHardy wrote:
> hard-coded size, but either way I don't like introducing this
> limitation just to work around the small uglyness required to
> keep a pointer inside the per-instance match data. We already
> have multiple precedents for this.

  Indeed, there are multiple precedents for this. For example: CLUSTERIP 
(already in mainline) is by far the ugliest hack I've seen in any Netfilter 
code. :)

-- 
 Regards,
  Krisztian Kovacs
