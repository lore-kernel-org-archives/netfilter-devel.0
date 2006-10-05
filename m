From: Deti Fliegl <deti@fliegl.de>
Subject: Re: Can i have a rate limit per source IP Address in IPSet?
Date: Thu, 05 Oct 2006 13:11:05 +0200
Message-ID: <4524E849.5020604@fliegl.de>
References: <b322db070610050006v73e69354t8d0106f2eec51597@mail.gmail.com>	
	<4524B968.303@fliegl.de>	
	<b322db070610050243s3a1d65cfqd4cf0ff35abab96e@mail.gmail.com>	
	<4524D64C.4070203@fliegl.de>	
	<b322db070610050306r60bcb242i132b58ec70c0bc3d@mail.gmail.com>	
	<4524DAB8.9000409@fliegl.de>
	<b322db070610050332q1dc3c239v6e24f7522634355d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Retesh Chadha <retesh.chadha@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <b322db070610050332q1dc3c239v6e24f7522634355d@mail.gmail.com>
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

Retesh Chadha wrote:
> I get following error when i do the same -
> 
> linux:~ # iptables -A INPUT --match hashlimit --hashlimit 1/s
> --hashlimit-mode srcip --hashlimit-name foo -j LOG
> iptables: No chain/target/match by that name
Make sure you have a kernel (~ >2.6.12) with 
CONFIG_IP_NF_MATCH_HASHLIMIT enabled.


Deti
