From: Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Mon, 04 Apr 2005 23:32:05 +0800
Message-ID: <20050404232509.0238.LARK@linux.net.cn>
References: <20050404230336.0235.LARK@linux.net.cn>
	<20050404150638.GA32081@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050404150638.GA32081@roonstrasse.net>
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

Hi Max Kellermann,

Error message

Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
unable to find ladd slot in src /tmp/pom-10691/include/linux/netfilter_ipv4/ip_conntrack.h 
(./h323-conntrack-nat/linux-2.6.11/./include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3)

ladd_3 looks like

        /* insert conntrack helper private data (expect) here */
        struct ip_ct_h225_expect exp_h225_info;

But ip_conntrac.h in 2.6.11 and 2.6.11.6 is

-- snip --
union ip_conntrack_expect_proto {
        /* insert expect proto private data here */
};
-- snip --


Acutally, rtsp/mms/h323 all failed on this. If I edit ip_conntrack.h by
hand and fix the insertion marker, then the pom-ng can be applied but
can't be compiled.


Here it is 23:30, so I say 'tomorrow' means I want to get a break now :)


On Mon, 4 Apr 2005 17:06:38 +0200, Max Kellermann <max@duempel.org> wrote:

> On 2005/04/04 17:04, Wang Jian <lark@linux.net.cn> wrote:
> > I tried it once with 2.6.11 and 2.6.11.6, both failed. But I will try it
> > again tomorrow.
> 
> What failed exactly? Message? Reject file?
> 
> I guess changing the "time" parameter (= tomorrow) won't help in this
> case ;)
> 
> Max
> 



-- 
  lark
