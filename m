From: Deti Fliegl <deti@fliegl.de>
Subject: Re: Can i have a rate limit per source IP Address in IPSet?
Date: Thu, 05 Oct 2006 09:51:04 +0200
Message-ID: <4524B968.303@fliegl.de>
References: <b322db070610050006v73e69354t8d0106f2eec51597@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Retesh Chadha <retesh.chadha@gmail.com>
In-Reply-To: <b322db070610050006v73e69354t8d0106f2eec51597@mail.gmail.com>
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

better use match 'hashlimit' for your purpose. Example:

iptables --append FORWARD --match hashlimit --hashlimit 1/s 
--hashlimit-mode srcip --jump ACCEPT

This would limit the number of requests from an specific IP address to 
1 per second.

Regards,

Deti
