From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: question regarding iptables tuning (was Re: iptables denial of services)
Date: Sat, 17 Apr 2004 19:22:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408167F2.9060501@fl.priv.at>
References: <Pine.LNX.4.44.0404171843020.22016-100000@filer.marasystems.com>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404171843020.22016-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote on 17.04.2004 18:49 MET:
> On Sat, 17 Apr 2004, Friedrich Lobenstock wrote:
> 
>>Can you give some details about those limits? Are there any numbers 
>>availabe that relate that to memory/cpu/....?
> 
> The default number of sessions is based on amount of memory but can
> easily be tuned at boot time.. or even runtime but then with a slight
> performance penalty.
> 
> http://www.netfilter.org/documentation/FAQ/netfilter-faq-3.html#ss3.7

Thanks, but can you give some background info about the hash size parameter 
of ip_conntrack as the description on the page above is rather lacking any 
reasons:
- Is this parameter automatically sized according to the amount of
   installed memory?
- How is it related to ip_conntrack_max?
- What's the amount of memory that is allocated based on this
   parameter?

Any suggestions for those parameters that are based on your experiences?

-- 
MfG / Regards
Friedrich Lobenstock
