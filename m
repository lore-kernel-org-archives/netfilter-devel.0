From: Pablo Neira <pablo@eurodev.net>
Subject: Re: kernel panic with ctnetlink/nfnetlink
Date: Thu, 16 Jun 2005 01:39:13 +0200
Message-ID: <42B0BC21.3020004@eurodev.net>
References: <20050615164034.GA15168@safetpin.homeunix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pud@subnet666.de
In-Reply-To: <20050615164034.GA15168@safetpin.homeunix.org>
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

pud wrote:
> hey,
> 
> when i apply conntrack-event-api/ctnetlink/nfnetlink-
> (i wanted to try the userspace conntrack tool)
> patches from recent svn, i always get a kernel panic
> after 1-4 hours in process swapper
> call trace says, that ip_finish_output2 is called, then
> swapper, and again...
> don't know, maybe somebody knows why this causes a panic...

Please post the whole oops. Are you doing something with the conntrack
tool? Appreaciate a more detailled description, ruleset, etc...

--
Pablo
