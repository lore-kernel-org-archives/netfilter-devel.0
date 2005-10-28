From: Deti Fliegl <deti@fliegl.de>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Fri, 28 Oct 2005 11:26:59 +0200
Message-ID: <4361EEE3.4030609@fliegl.de>
References: <4361EAAB.1090206@fliegl.de> <4361EEC2.9010504@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4361EEC2.9010504@eurodev.net>
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

Pablo Neira wrote:
> Deti Fliegl wrote:
> 
>> Reading /proc/net/ip_conntrack seems to lock the table as long as 
>> being read which causes delays and loss in network traffic. Now I'm 
>> trying to use the conntrack utility from the subversion repository to 
>> list the conntrack table. This in turn prints out some "Unknown 
>> Attribute 5" lines and what's even worse it runs very often into a 
>> segmentation fault at
> 
> 
> kernel version? userspace tools and libraries versions?
see above: kernel 2.6.14 - tools from svn @ now-30min
