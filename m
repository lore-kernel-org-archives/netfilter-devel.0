From: Karlis Peisenieks <karlis@mt.lv>
Subject: Re: [netfilter-core] recent in_range fix uncovered another bug?
Date: Thu, 11 Sep 2003 10:15:49 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030911071549.GA1045@mt.lv>
References: <20030910110555.GA30240@mt.lv> <20030911061644.B23BC2C0A7@lists.samba.org> <20030911070956.GA950@mt.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030911070956.GA950@mt.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 11, 2003 at 10:09:56AM +0300, Karlis Peisenieks wrote:

> This patch solves "lockup" problem, but what about tons of equal 
> conntracks?

Sorry, I overlooked how confirm works, now it is clear that two equal 
conntracks can not be on lists. The only problem stays that potentially 
innocent packets (e.g. in case of icmp echo request) get dropped.

Is it correct?


Karlis
