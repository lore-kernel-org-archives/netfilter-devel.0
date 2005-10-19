From: Pablo Neira <pablo@eurodev.net>
Subject: Re: any Api to program with iptables without system(...)
Date: Wed, 19 Oct 2005 19:30:42 +0200
Message-ID: <435682C2.1000504@eurodev.net>
References: <bc16c9260510171445u5584db7t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: iAc <iacopo.masi@gmail.com>
In-Reply-To: <bc16c9260510171445u5584db7t@mail.gmail.com>
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

iAc wrote:
> I have to develop a program that interface with Iptables but for security
> reason I'm canno use system call System(iptables command).
> I have try to find out a better way but I didn't find nothing.
> Someone there can show me how can I interact with iptables withou system
> call "System etc. etc." ??

No, the iptables API is not documented. This is one of the current flaws 
that still persist in iptables. The safest way to work with iptables is 
using system(...)
