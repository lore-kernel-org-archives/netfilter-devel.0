From: Deti Fliegl <deti@fliegl.de>
Subject: Re: Can i have a rate limit per source IP Address in IPSet?
Date: Fri, 06 Oct 2006 09:40:00 +0200
Message-ID: <45260850.4000108@fliegl.de>
References: <b322db070610050006v73e69354t8d0106f2eec51597@mail.gmail.com>	
	<4524B968.303@fliegl.de>	
	<b322db070610050243s3a1d65cfqd4cf0ff35abab96e@mail.gmail.com>	
	<4524D64C.4070203@fliegl.de>	
	<b322db070610050306r60bcb242i132b58ec70c0bc3d@mail.gmail.com>	
	<4524DAB8.9000409@fliegl.de>	
	<b322db070610050332q1dc3c239v6e24f7522634355d@mail.gmail.com>	
	<4524E849.5020604@fliegl.de>
	<b322db070610052343y2705e6cfjf3d432d067235db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Retesh Chadha <retesh.chadha@gmail.com>
In-Reply-To: <b322db070610052343y2705e6cfjf3d432d067235db@mail.gmail.com>
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


Retesh Chadha wrote:
> I have another question though. I now need to set a limit per src dst
> pair, but I get a bad mode for  hashlimit-mode srcipdstip.
> I give the following command -
> 
> iptables -A INPUT_CHAIN --match hashlimit --hashlimit 1000/s
> --hashlimit-mode srcip-dstip --hashlimit-name foo -m set --set KNOWN
> src,dst -j ACCEPT

There is a minor documentation bug: '--hashlimit-mode srcip,dstip' 
should work for you.

Deti
