From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: e1000 with ip_conntrack at 40k/s upload
Date: Thu, 11 Dec 2003 09:25:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD829E9.20003@balabit.hu>
References: <20031211011949.GA4664@ddiworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: joel reed <jreed@ddiworld.com>
In-Reply-To: <20031211011949.GA4664@ddiworld.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

joel reed wrote:
> When i run 2.6.0-test11 with an e1000 card and ip_conntrack
> i get 40k/s upload speed. with the exact same config on
> 2.4.22-1.2129.nptlsmp i get 6M/s uploads. download speed is
> never effected.
> 
> this issue was reported previously:
> http://lists.netfilter.org/pipermail/netfilter/2003-October/047436.html

   Isn't this the recently solved ip_conntrack && TSO problem? Maybe you 
should check out the LKML thread on the issue, and try David Millers patch:

   http://lkml.org/lkml/2003/12/5/179

-- 
   Regards,
     Krisztian KOVACS
