From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: H.323 progress.
Date: Thu, 20 May 2004 07:35:00 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40ABB6E4.3000201@sauce.co.nz>
References: <Pine.LNX.4.44.0405190814480.19467-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0405190814480.19467-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Wed, 19 May 2004, Richard Scobie wrote:
> 
> 
>>Two offices each with an iptables firewall and a site to site VPN 
>>between them - the video gear is configured to connect to each others 
>>private network address through the VPN.
> 
> 
> Is the traffic between the two offices NAT:ed, or just forwarded over the 
> VPN?
> 
> There should be no need for NAT on office<->office traffic.
> 

Perhaps I have my terminology wrong. I was thinking that NAT is used at 
each end, translating between the 2 different networks. Thinking about 
it, as you say, it is not needed - there is only routing involved.

I am unsure where the problem lies then because as I mentioned earlier, 
the same video equipment configured the same way using 2.2.X kernels and 
ipchains works fine.

Regards,

Richard
